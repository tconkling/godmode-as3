//
// godmode

package godmode {

import godmode.core.BehaviorTask;
import godmode.core.ScopedResource;
import godmode.core.RandomStream;
import godmode.core.Semaphore;
import godmode.core.TimeKeeper;
import godmode.data.Entry;
import godmode.data.MutableEntry;
import godmode.decorator.DelayFilter;
import godmode.decorator.LoopingDecorator;
import godmode.decorator.PredicateFilter;
import godmode.decorator.SemaphoreDecorator;
import godmode.decorator.ScopeDecorator;
import godmode.pred.AndPredicate;
import godmode.pred.BehaviorPredicate;
import godmode.pred.EntryExistsPred;
import godmode.pred.FunctionPredicate;
import godmode.pred.NotPredicate;
import godmode.pred.OrPredicate;
import godmode.selector.ParallelSelector;
import godmode.selector.PrioritySelector;
import godmode.selector.SequenceSelector;
import godmode.selector.WeightedSelector;
import godmode.selector.WeightedTask;
import godmode.task.DelayTask;
import godmode.task.FunctionTask;
import godmode.task.NoOpTask;
import godmode.task.RemoveEntryTask;
import godmode.task.StoreEntryTask;

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
    public function runWhile (pred :BehaviorPredicate, task :BehaviorTask) :PredicateFilter {
        return new PredicateFilter(pred, task);
    }

    /**
     * Runs the given task if the predicate/task is true/returns SUCCESS.
     * The predicate is only evaluated before entering the task.
     */
    public function enterIf (pred :BehaviorTask, task :BehaviorTask) :SequenceSelector {
        return sequence(pred, task);
    }

    /** Stops running the task if the predicate is true */
    public function exitIf (pred :BehaviorPredicate, task :BehaviorTask) :PredicateFilter {
        return runWhile(not(pred), task);
    }

    /**
     * Runs the given task, using the given ScopedResource. The resource will be acquired
     * before the task is run, and released when the task is complete (or gets interrupted).
     *
     * (This is similar to a 'using' statement (or try/finally) in a structured language.)
     */
    public function using (resource :ScopedResource, task :BehaviorTask) :ScopeDecorator {
        // combine multiple using(resource1, using(resource2, ... statements into one
        if (task is ScopeDecorator) {
            const using :ScopeDecorator = ScopeDecorator(task);
            using.addResource(resource);
            return using;

        } else {
            return new ScopeDecorator(task, new <ScopedResource>[ resource ]);
        }
    }

    /** Runs children in sequence until one fails, or all succeed */
    public function sequence (...children) :SequenceSelector {
        // reuse existing task if possible
        if (children.length > 0 && children[0] is SequenceSelector) {
            const seq :SequenceSelector = children[0];
            for (var ii :int = 1; ii < children.length; ++ii) {
                seq.addTask(children[ii]);
            }
            return seq;

        } else {
            return new SequenceSelector(taskVector(children));
        }
    }

    /** Runs all children concurrently until one fails */
    public function parallel (...children) :ParallelSelector {
        const TYPE :int = ParallelSelector.ALL_SUCCESS;

        // reuse existing task if possible
        if (children.length > 0 && children[0] is ParallelSelector &&
            ParallelSelector(children[0]).type == TYPE) {

            const parallel :ParallelSelector = children[0];
            for (var ii :int = 1; ii < children.length; ++ii) {
                parallel.addTask(children[ii]);
            }
            return parallel;

        } else {
            return new ParallelSelector(TYPE, taskVector(children));
        }
    }

    /** Runs a task a specified number of times */
    public function loop (count :int, task :BehaviorTask) :BehaviorTask {
        return new LoopingDecorator(LoopingDecorator.BREAK_NEVER, count, task);
    }

    /** Loops a task forever */
    public function loopForever (task :BehaviorTask) :LoopingDecorator {
        return new LoopingDecorator(LoopingDecorator.BREAK_NEVER, 0, task);
    }

    /** Runs a task until it succeeds */
    public function loopUntilSuccess (task :BehaviorTask) :LoopingDecorator {
        return new LoopingDecorator(LoopingDecorator.BREAK_ON_SUCCESS, 0, task);
    }

    /** Loops a task until it fails */
    public function loopUntilFail (task :BehaviorTask) :LoopingDecorator {
        return new LoopingDecorator(LoopingDecorator.BREAK_ON_FAIL, 0, task);
    }

    /** Loops a task until it succeeds or fails */
    public function loopUntilComplete (task :BehaviorTask) :LoopingDecorator {
        return new LoopingDecorator(LoopingDecorator.BREAK_ON_COMPLETE, 0, task);
    }

    /** Runs a task, and ensure that it won't be re-run until a minimum amount of time has elapsed */
    public function withRepeatDelay (minDelay :Entry, task :BehaviorTask) :DelayFilter {
        return new DelayFilter(minDelay, _timeKeeper, task);
    }

    /**
     * Runs the first task that returns a non-FAIL status.
     * Higher-priority tasks (those higher in the list) can interrupt lower-priority tasks that
     * are running.
     */
    public function selectWithPriority (...children) :PrioritySelector {
        return new PrioritySelector(taskVector(children));
    }

    /** Randomly selects a task to run */
    public function selectRandomly (rng :RandomStream, ...childrenAndWeights) :WeightedSelector {
        var n :uint = childrenAndWeights.length;
        var children :Vector.<WeightedTask> = new Vector.<WeightedTask>(n >> 1, true);
        for (var ii :int = 0; ii < n; ii += 2) {
            children.push(new WeightedTask(childrenAndWeights[ii], childrenAndWeights[ii + 1]));
        }
        return new WeightedSelector(rng, children);
    }

    /** Wait a specified amount of time */
    public function wait (time :Entry) :DelayTask {
        return new DelayTask(time);
    }

    /** Calls a function */
    public function call (f :Function) :FunctionTask {
        return new FunctionTask(f);
    }

    /** Runs a task if the given semaphore is successfully acquired */
    public function withSemaphore (semaphore :Semaphore, task :BehaviorTask) :SemaphoreDecorator {
        return new SemaphoreDecorator(semaphore, task);
    }

    /** Removes the given value from its blackboard */
    public function removeEntry (entry :MutableEntry) :RemoveEntryTask {
        return new RemoveEntryTask(entry);
    }

    /** Stores a value in the blackboard */
    public function storeEntry (entry :MutableEntry, storeVal :*) :StoreEntryTask {
        return new StoreEntryTask(entry, storeVal);
    }

    /** Does nothing */
    public function noOp () :NoOpTask {
        return NoOpTask.SUCCESS;
    }

    /** Returns !pred */
    public function not (pred :BehaviorPredicate) :BehaviorPredicate {
        return (pred is NotPredicate ? NotPredicate(pred).pred : new NotPredicate(pred));
    }

    /** ANDs the given preds together */
    public function and (...preds) :AndPredicate {
        // re-use existing predicate if possible
        if (preds.length > 0 && preds[0] is AndPredicate) {
            const parent :AndPredicate = preds[0];
            for (var ii :int = 0; ii < preds.length; ++ii) {
                parent.addPred(preds[ii]);
            }
            return parent;

        } else {
            return new AndPredicate(predVector(preds));
        }
    }

    /** ORs the given preds together */
    public function or (...preds) :OrPredicate {
        // re-use existing predicate if possible
        if (preds.length > 0 && preds[0] is OrPredicate) {
            const parent :OrPredicate = preds[0];
            for (var ii :int = 0; ii < preds.length; ++ii) {
                parent.addPred(preds[ii]);
            }
            return parent;

        } else {
            return new OrPredicate(predVector(preds));
        }
    }

    /** Returns a Predicate that calls the given function */
    public function pred (f :Function) :FunctionPredicate {
        return new FunctionPredicate(f);
    }

    /** Tests the existence of the given entry in its blackboard */
    public function entryExists (value :Entry) :EntryExistsPred {
        return new EntryExistsPred(value);
    }

    protected function taskVector (arr :Array) :Vector.<BehaviorTask> {
        var n :int = arr.length;
        var out :Vector.<BehaviorTask> = new Vector.<BehaviorTask>(n, false);
        for (var ii :int = 0; ii < n; ++ii) {
            out[ii] = arr[ii];
        }
        return out;
    }

    protected function predVector (arr :Array) :Vector.<BehaviorPredicate> {
        var n :int = arr.length;
        var out :Vector.<BehaviorPredicate> = new Vector.<BehaviorPredicate>(n, false);
        for (var ii :int = 0; ii < n; ++ii) {
            out[ii] = arr[ii];
        }
        return out;
    }

    protected var _timeKeeper :TimeKeeper;
}

}
