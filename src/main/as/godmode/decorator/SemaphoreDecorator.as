//
// godmode

package godmode.decorator {

import godmode.core.Semaphore;
import godmode.core.StatefulBehaviorTask;
import godmode.core.BehaviorTask;
import godmode.core.BehaviorTaskContainer;

/** Runs its task only when it has acquired the given semaphore */
public class SemaphoreDecorator extends StatefulBehaviorTask
    implements BehaviorTaskContainer
{
    public function SemaphoreDecorator (semaphore :Semaphore, task :BehaviorTask) {
        _task = task;
        _semaphore = semaphore;
    }

    public function get children () :Vector.<BehaviorTask> {
        return new <BehaviorTask>[ _task ];
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

    override protected function updateTask (dt :Number) :int {
        if (!_semaphoreAcquired) {
            _semaphoreAcquired = _semaphore.acquire();
            if (!_semaphoreAcquired) {
                return FAIL;
            }
        }
        return _task.update(dt);
    }

    protected var _task :BehaviorTask;
    protected var _semaphore :Semaphore;

    protected var _semaphoreAcquired :Boolean;
}
}
