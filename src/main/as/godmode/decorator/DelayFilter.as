//
// godmode

package godmode.decorator {

import godmode.core.StatefulTask;
import godmode.core.Task;
import godmode.core.TaskContainer;
import godmode.core.TimeKeeper;
import godmode.core.Value;

/**
 * A decorator that prevents a task from being run more than once in the given interval.
 */
public class DelayFilter extends StatefulTask
    implements TaskContainer
{
    public function DelayFilter (name :String, minDelay :Value, timeKeeper :TimeKeeper, task :Task) {
        super(name);
        _task = task;
        _minDelay = minDelay;
        _timeKeeper = timeKeeper;
        _lastCompletionTime = -Number.MAX_VALUE;
    }
    
    public function get children () :Vector.<Task> {
        return new <Task>[ _task ];
    }
    
    override protected function reset () :void {
        if (_taskRunning) {
            _task.deactivate();
            _taskRunning = false;
            _inited = false;
        }
    }
    
    override protected function update (dt :Number) :int {
        if (!_inited) {
            _curDelay = _minDelay.getValue();
            _inited = true;
        }
        
        var now :Number = _timeKeeper.now();
        if (!_taskRunning && ((now - _lastCompletionTime) < _curDelay)) {
            // can't run.
            return FAIL;
        }
        
        var status :int = _task.updateTask(dt);
        _taskRunning = (status == RUNNING);
        if (!_taskRunning) {
            _inited = false;
        }
        if (status == SUCCESS) {
            _lastCompletionTime = now;
        }
        return status;
    }
    
    protected var _task :Task;
    protected var _minDelay :Value;
    protected var _timeKeeper :TimeKeeper;
    
    protected var _inited :Boolean;
    protected var _curDelay :Number;
    protected var _taskRunning :Boolean;
    protected var _lastCompletionTime :Number;
}
}
