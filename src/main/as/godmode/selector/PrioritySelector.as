//
// godmode

package godmode.selector {

import godmode.core.StatefulTask;
import godmode.core.Task;
import godmode.core.TaskContainer;

/**
 * A selector that tries to run each of its children, every update, until it finds one that
 * succeeds.
 *
 * Since children are always run in priority-order, a higher-priority task can interrupt a
 * lower-priority one that began running on a previous update.
 */
public class PrioritySelector extends StatefulTask
    implements TaskContainer
{
    public function PrioritySelector (name :String, children :Vector.<Task>) {
        super(name);
        _children = children;
    }
    
    public function get children () :Vector.<Task> {
        return _children;
    }
    
    override protected function reset () :void {
        if (_runningTask != null) {
            _runningTask.deactivate();
            _runningTask = null;
        }
    }
    
    override protected function update (dt :Number) :int {
        // iterate all children till we find one that doesn't fail
        var status :int = SUCCESS;
        for each (var task :Task in _children) {
            status = task.updateTask(dt);
            
            // if the child succeeded, or is still running, we exit the loop
            if (status != FAIL) {
                // Did we interrupt a lower-priority task that was already running?
                // nb: the lower-priority task will be deactivated *after* the higher-priority
                // one is activated
                if (_runningTask != task && _runningTask != null) {
                    _runningTask.deactivate();
                }
                
                _runningTask = (status == RUNNING ? task : null);
                break;
            }
        }
        
        return status;
    }
    
    protected var _children :Vector.<Task>;
    protected var _runningTask :Task;
}
}
