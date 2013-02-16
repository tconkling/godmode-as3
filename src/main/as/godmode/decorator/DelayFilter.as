//
// godmode

package godmode.decorator {

import godmode.core.StatefulBehaviorTask;
import godmode.core.BehaviorTask;
import godmode.core.BehaviorTaskContainer;
import godmode.core.TimeKeeper;
import godmode.data.Entry;

/**
 * A decorator that prevents a task from being run more than once in the given interval.
 */
public class DelayFilter extends StatefulBehaviorTask
    implements BehaviorTaskContainer
{
    public function DelayFilter (minDelay :Entry, timeKeeper :TimeKeeper, task :BehaviorTask) {
        _task = task;
        _minDelay = minDelay;
        _timeKeeper = timeKeeper;
        _lastCompletionTime = -Number.MAX_VALUE;
    }

    public function get children () :Vector.<BehaviorTask> {
        return new <BehaviorTask>[ _task ];
    }

    override protected function reset () :void {
        if (_taskRunning) {
            _task.deactivate();
            _taskRunning = false;
        }
    }

    override protected function updateTask (dt :Number) :int {
        var now :Number = _timeKeeper.timeNow();
        if (!_taskRunning && ((now - _lastCompletionTime) < _minDelay.value)) {
            // can't run.
            return FAIL;
        }

        var status :int = _task.update(dt);
        _taskRunning = (status == RUNNING);
        if (status == SUCCESS) {
            _lastCompletionTime = now;
        }
        return status;
    }

    protected var _task :BehaviorTask;
    protected var _minDelay :Entry;
    protected var _timeKeeper :TimeKeeper;

    protected var _taskRunning :Boolean;
    protected var _lastCompletionTime :Number;
}
}
