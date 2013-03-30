//
// godmode

package godmode.selector {

import godmode.core.BehaviorTask;
import godmode.core.BehaviorTaskContainer;
import godmode.core.StatefulBehaviorTask;

/**
 * Executes child tasks in sequence. Succeeds when all children have succeeded. Fails when
 * any child fails.
 */
public class SequenceSelector extends StatefulBehaviorTask
    implements BehaviorTaskContainer
{
    public function SequenceSelector (tasks :Vector.<BehaviorTask> = null) {
        _children = (tasks || new Vector.<BehaviorTask>());
    }

    public function addTask (task :BehaviorTask) :void {
        _children.push(task);
    }

    public function get children () :Vector.<BehaviorTask> {
        return _children;
    }

    override protected function reset () :void {
        if (_curChild != null) {
            _curChild.deactivate();
            _curChild = null;
        }
        _childIdx = 0;
    }

    override protected function updateTask (dt :Number) :int {
        while (_childIdx < _children.length) {
            _curChild = _children[_childIdx];
            var childStatus :int = _curChild.update(dt);
            if (childStatus == SUCCESS) {
                // the child completed. Move on to the next.
                _curChild = null;
                _childIdx++;
            } else {
                // RUNNING or FAIL return immediately
                return childStatus;
            }
        }

        // all our children have completed successfully
        return SUCCESS;
    }

    protected var _children :Vector.<BehaviorTask>;
    protected var _curChild :BehaviorTask;
    protected var _childIdx :int;
}
}
