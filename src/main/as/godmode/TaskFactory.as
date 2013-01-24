//
// godmode

package godmode {

import godmode.task.NoOpAction;
import godmode.task.TimerAction;
import godmode.task.FunctionTask;
import godmode.core.RandomStream;
import godmode.core.Semaphore;
import godmode.core.BehaviorTask;
import godmode.core.TimeKeeper;
import godmode.data.Value;
import godmode.decorator.DelayFilter;
import godmode.decorator.LoopingDecorator;
import godmode.decorator.PredicateFilter;
import godmode.decorator.SemaphoreGuardDecorator;
import godmode.pred.AndPredicate;
import godmode.pred.NotPredicate;
import godmode.pred.OrPredicate;
import godmode.pred.Predicate;
import godmode.selector.ParallelSelector;
import godmode.selector.PrioritySelector;
import godmode.selector.SequenceSelector;
import godmode.selector.WeightedSelector;
import godmode.selector.WeightedTask;

public class TaskFactory
{
    public function TaskFactory (timeKeeper :TimeKeeper) {
        _timeKeeper = timeKeeper;
    }
    
    /** Causes the next task created by the factory to have the given name */
    public function withName (name :String) :TaskFactory {
        _name = name;
        return this;
    }
    
    /** Runs the given task if its predicates succeed */
    public function iff (pred :Predicate, task :BehaviorTask) :BehaviorTask {
        return new PredicateFilter(takeName(), pred, task);
    }
    
    /** Runs children in sequence until one fails, or all succeed */
    public function sequence (...children) :BehaviorTask {
        return new SequenceSelector(takeName(), taskVector(children));
    }
    
    /** Runs all children concurrently until one fails */
    public function parallel (...children) :BehaviorTask {
        return new ParallelSelector(takeName(), ParallelSelector.ALL_SUCCESS, taskVector(children));
    }
    
    /** Loops a task until a condition is met */
    public function loop () :LoopingDecoratorBuilder {
        return new LoopingDecoratorBuilder(takeName());
    }
    
    /** Runs a task, and ensure that it won't be re-run until a minimum amount of time has elapsed */
    public function withRepeatDelay (minDelay :Value, task :BehaviorTask) :BehaviorTask {
        return new DelayFilter(takeName(), minDelay, _timeKeeper, task);
    }
    
    /**
     * Runs the first task that returns a non-FAIL status.
     * Higher-priority tasks (those higher in the list) can interrupt lower-priority tasks that
     * are running.
     */
    public function selectWithPriority (...children) :BehaviorTask {
        return new PrioritySelector(takeName(), taskVector(children));
    }
    
    /** Randomly selects a task to run */
    public function selectRandomly (rng :RandomStream, ...childrenAndWeights) :BehaviorTask {
        var n :uint = childrenAndWeights.length;
        var children :Vector.<WeightedTask> = new Vector.<WeightedTask>(n >> 1, true);
        for (var ii :int = 0; ii < n; ii += 2) {
            children.push(new WeightedTask(childrenAndWeights[ii], childrenAndWeights[ii + 1]));
        }
        return new WeightedSelector(takeName(), rng, children);
    }
    
    /** Wait a specified amount of time */
    public function wait (time :Value) :BehaviorTask {
        return new TimerAction(takeName(), time);
    }
    
    /** Calls a function */
    public function call (f :Function) :BehaviorTask {
        return new FunctionTask(takeName(), f);
    }
    
    /** Runs a task if the given semaphore is successfully acquired */
    public function withGuard (semaphore :Semaphore, task :BehaviorTask) :BehaviorTask {
        return new SemaphoreGuardDecorator(takeName(), semaphore, task);
    }
    
    /** Does nothing */
    public function noOp () :BehaviorTask {
        return new NoOpAction(takeName());
    }
    
    /** Returns !pred */
    public function not (pred :Predicate) :Predicate {
        return new NotPredicate(takeName(), pred);
    }
    
    /** ANDs the given preds together */
    public function and (...preds) :Predicate {
        return new AndPredicate(takeName(), predVector(preds));
    }
    
    /** ORs the given preds together */
    public function or (...preds) :Predicate {
        return new OrPredicate(takeName(), predVector(preds));
    }
    
    protected function takeName () :String {
        var name :String = _name;
        _name = null;
        return name;
    }
    
    protected function taskVector (arr :Array) :Vector.<BehaviorTask> {
        var n :int = arr.length;
        var out :Vector.<BehaviorTask> = new Vector.<BehaviorTask>(n, true);
        for (var ii :int = 0; ii < n; ++ii) {
            out.push(arr[ii]);
        }
        return out;
    }
    
    protected function predVector (arr :Array) :Vector.<Predicate> {
        var n :int = arr.length;
        var out :Vector.<Predicate> = new Vector.<Predicate>(n, true);
        for (var ii :int = 0; ii < n; ++ii) {
            out.push(arr[ii]);
        }
        return out;
    }
    
    protected var _name :String;
    protected var _timeKeeper :TimeKeeper;
}

}
import godmode.core.BehaviorTask;
import godmode.decorator.LoopingDecorator;
import godmode.decorator.PredicateFilter;
import godmode.pred.Predicate;

class LoopingDecoratorBuilder {
    public function LoopingDecoratorBuilder (name :String) {
        _name = name;
        _type = LoopingDecorator.BREAK_NEVER;
    }
    
    /** Loops the task forever */
    public function forever (task :BehaviorTask) :BehaviorTask {
        return new LoopingDecorator(_name, LoopingDecorator.BREAK_NEVER, 0, task);
    }
    
    /** Loops the task until it succeeds */
    public function untilSuccess (task :BehaviorTask) :BehaviorTask {
        return new LoopingDecorator(_name, LoopingDecorator.BREAK_ON_SUCCESS, 0, task);
    }
    
    /** Loops the task until it fails */
    public function untilFail (task :BehaviorTask) :BehaviorTask {
        return new LoopingDecorator(_name, LoopingDecorator.BREAK_ON_FAIL, 0, task);
    }
     
    /** Loops the task the given number of times */
    public function withCount (loopCount :int, task :BehaviorTask) :BehaviorTask {
        return new LoopingDecorator(_name, LoopingDecorator.BREAK_NEVER, loopCount, task);
    }
    
    protected var _name :String;
    protected var _type :int;
    protected var _loopCount :int;
}
