//
// godmode

package godmode.decorator {

import godmode.core.BehaviorTask;
import godmode.core.BehaviorTaskContainer;
import godmode.core.ScopedResource;
import godmode.core.StatefulBehaviorTask;

public class ScopeDecorator extends StatefulBehaviorTask
    implements BehaviorTaskContainer
{
    public function ScopeDecorator (task :BehaviorTask, resources :Vector.<ScopedResource> = null) {
        _task = task;
        _resources = (resources || new Vector.<ScopedResource>());
    }

    public function addResource (resource :ScopedResource) :void {
        _resources.push(resource);
    }

    public function get children () :Vector.<BehaviorTask> {
        return new Vector.<BehaviorTask>(_task);
    }

    override protected function reset () :void {
        if (_entered) {
            _entered = false;
            for each (var resource :ScopedResource in _resources) {
                resource.release();
            }
        }
        _task.deactivate();
    }

    override protected function updateTask (dt :Number) :int {
        if (!_entered) {
            _entered = true;
            for each (var resource :ScopedResource in _resources) {
                resource.acquire();
            }
        }
        return _task.update(dt);
    }

    protected var _task :BehaviorTask;
    protected var _resources :Vector.<ScopedResource>;

    protected var _entered :Boolean;
}
}
