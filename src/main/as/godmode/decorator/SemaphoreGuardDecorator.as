//
// godmode

package godmode.decorator {

import godmode.core.Semaphore;
import godmode.core.StatefulTask;
import godmode.core.Task;
import godmode.core.TaskContainer;

public class SemaphoreGuardDecorator extends StatefulTask
    implements TaskContainer
{
    public function SemaphoreGuardDecorator (name :String, semaphore :Semaphore, task :Task) {
        super(name);
        _task = task;
        _semaphore = semaphore;
    }
    
    public function get children () :Vector.<Task> {
        return new <Task>[ _task ];
    }
    
    override public function get description () :String {
        return super.description + ":" + _semaphore.name;
    }
    
    override protected function reset () :void {
        if (_semaphoreAcquired) {
            _semaphore.release();
            _semaphoreAcquired = false;
        }
        _task.deactivate();
    }
    
    override protected function update (dt :Number) :int {
        if (!_semaphoreAcquired) {
            _semaphoreAcquired = _semaphore.acquire();
            if (!_semaphoreAcquired) {
                return FAIL;
            }
        }
        return _task.updateTask(dt);
    }
    
    protected var _task :Task;
    protected var _semaphore :Semaphore;
    
    protected var _semaphoreAcquired :Boolean;
}
}
