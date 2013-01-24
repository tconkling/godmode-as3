//
// godmode

package godmode.selector {

import godmode.core.StatefulTask;
import godmode.core.Task;
import godmode.core.TaskContainer;

/**
 * Executes child tasks in sequence. Succeeds when all children have succeeded. Fails when
 * any child fails.
 */
public class SequenceSelector extends StatefulTask
    implements TaskContainer
{
    public function SequenceSelector (name :String, children :Vector.<Task>) {
        super(name);
        _children = children;
    }
    
    public function get children () :Vector.<Task> {
        return _children;
    }
    
    override protected function reset () :void {
        if (_curChild != null) {
            _curChild.deactivate();
            _curChild = null;
        }
        _childIdx = 0;
    }
    
    override protected function update (dt :Number) :int {
        while (_childIdx < _children.length) {
            _curChild = _children[_childIdx];
            var childStatus :int = _curChild.updateTask(dt);
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
    
    protected var _children :Vector.<Task>;
    protected var _curChild :Task;
    protected var _childIdx :int;
}
}
