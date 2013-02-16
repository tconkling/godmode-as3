//
// godmode

package godmode {

import godmode.core.BehaviorTask;
import godmode.core.RandomStream;
import godmode.core.Semaphore;
import godmode.core.TimeKeeper;
import godmode.data.Entry;
import godmode.data.MutableEntry;
import godmode.decorator.DelayFilter;
import godmode.decorator.LoopingDecorator;
import godmode.decorator.PredicateFilter;
import godmode.decorator.SemaphoreGuardDecorator;
import godmode.pred.AndPredicate;
import godmode.pred.EntryExistsPred;
import godmode.pred.NotPredicate;
import godmode.pred.OrPredicate;
import godmode.pred.Predicate;
import godmode.selector.ParallelSelector;
import godmode.selector.PrioritySelector;
import godmode.selector.SequenceSelector;
import godmode.selector.WeightedSelector;
import godmode.selector.WeightedTask;
import godmode.task.FunctionTask;
import godmode.task.NoOpAction;
import godmode.task.RemoveEntryAction;
import godmode.task.StoreEntryAction;
import godmode.task.TimerAction;

public class TaskFactory
{
    public function TaskFactory (timeKeeper :TimeKeeper) {
        _timeKeeper = timeKeeper;
    }

// TODO
//    /** Causes the next task created by the factory to have the given name */
//    public function withName (name :String) :TaskFactory {
//        _name = name;
//        return this;
//    }

    /** Runs the given task while the predicate is true */
    public function runWhile (pred :Predicate, task :BehaviorTask) :BehaviorTask {
        return new PredicateFilter(pred, task);
    }

    /**
     * Runs the given task if the predicate is true. The predicate is only evaluated
     * before entering the task.
     */
    public function enterIf (pred :Predicate, task :BehaviorTask) :BehaviorTask {
        return sequence(pred, task);
    }

    /** Stops running the task if the predicate is true */
    public function exitIf (pred :Predicate, task :BehaviorTask) :BehaviorTask {
        return runWhile(new NotPredicate(pred), task);
    }

    /** Runs children in sequence until one fails, or all succeed */
    public function sequence (...children) :BehaviorTask {
        return new SequenceSelector(taskVector(children));
    }

    /** Runs all children concurrently until one fails */
    public function parallel (...children) :BehaviorTask {
        return new ParallelSelector(ParallelSelector.ALL_SUCCESS, taskVector(children));
    }

    /** Runs a task a specified number of times */
    public function forCount (count :int, task :BehaviorTask) :BehaviorTask {
        return new LoopingDecorator(LoopingDecorator.BREAK_NEVER, count, task);
    }

    /** Loops a task forever */
    public function forever (task :BehaviorTask) :BehaviorTask {
        return new LoopingDecorator(LoopingDecorator.BREAK_NEVER, 0, task);
    }

    /** Runs a task until it succeeds */
    public function untilSuccess (task :BehaviorTask) :BehaviorTask {
        return new LoopingDecorator(LoopingDecorator.BREAK_ON_SUCCESS, 0, task);
    }

    /** Loops a task until it fails */
    public function untilFail (task :BehaviorTask) :BehaviorTask {
        return new LoopingDecorator(LoopingDecorator.BREAK_ON_FAIL, 0, task);
    }

    /** Runs a task, and ensure that it won't be re-run until a minimum amount of time has elapsed */
    public function withRepeatDelay (minDelay :Entry, task :BehaviorTask) :BehaviorTask {
        return new DelayFilter(minDelay, _timeKeeper, task);
    }

    /**
     * Runs the first task that returns a non-FAIL status.
     * Higher-priority tasks (those higher in the list) can interrupt lower-priority tasks that
     * are running.
     */
    public function selectWithPriority (...children) :BehaviorTask {
        return new PrioritySelector(taskVector(children));
    }

    /** Randomly selects a task to run */
    public function selectRandomly (rng :RandomStream, ...childrenAndWeights) :BehaviorTask {
        var n :uint = childrenAndWeights.length;
        var children :Vector.<WeightedTask> = new Vector.<WeightedTask>(n >> 1, true);
        for (var ii :int = 0; ii < n; ii += 2) {
            children.push(new WeightedTask(childrenAndWeights[ii], childrenAndWeights[ii + 1]));
        }
        return new WeightedSelector(rng, children);
    }

    /** Wait a specified amount of time */
    public function wait (time :Entry) :BehaviorTask {
        return new TimerAction(time);
    }

    /** Calls a function */
    public function call (f :Function) :BehaviorTask {
        return new FunctionTask(f);
    }

    /** Runs a task if the given semaphore is successfully acquired */
    public function withGuard (semaphore :Semaphore, task :BehaviorTask) :BehaviorTask {
        return new SemaphoreGuardDecorator(semaphore, task);
    }

    /** Removes the given value from its blackboard */
    public function removeEntry (entry :MutableEntry) :BehaviorTask {
        return new RemoveEntryAction(entry);
    }

    /** Stores a value in the blackboard */
    public function storeEntry (entry :MutableEntry, storeVal :*) :BehaviorTask {
        return new StoreEntryAction(entry, storeVal);
    }

    /** Does nothing */
    public function noOp () :BehaviorTask {
        return new NoOpAction();
    }

    /** Returns !pred */
    public function not (pred :Predicate) :Predicate {
        return new NotPredicate(pred);
    }

    /** ANDs the given preds together */
    public function and (...preds) :Predicate {
        return new AndPredicate(predVector(preds));
    }

    /** ORs the given preds together */
    public function or (...preds) :Predicate {
        return new OrPredicate(predVector(preds));
    }

    /** Tests the existence of the given entry in its blackboard */
    public function entryExists (value :Entry) :Predicate {
        return new EntryExistsPred(value);
    }

    protected function taskVector (arr :Array) :Vector.<BehaviorTask> {
        var n :int = arr.length;
        var out :Vector.<BehaviorTask> = new Vector.<BehaviorTask>(n, true);
        for (var ii :int = 0; ii < n; ++ii) {
            out[ii] = arr[ii];
        }
        return out;
    }

    protected function predVector (arr :Array) :Vector.<Predicate> {
        var n :int = arr.length;
        var out :Vector.<Predicate> = new Vector.<Predicate>(n, true);
        for (var ii :int = 0; ii < n; ++ii) {
            out[ii] = arr[ii];
        }
        return out;
    }

    protected var _timeKeeper :TimeKeeper;
}

}
