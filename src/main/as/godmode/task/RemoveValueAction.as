//
// godmode

package godmode.task {

import godmode.core.BehaviorTask;
import godmode.data.MutableValue;

public class RemoveValueAction extends BehaviorTask
{
    public function RemoveValueAction (value :MutableValue) {
        _value = value;
    }
    
    override protected function updateTask (dt :Number) :int {
        _value.remove();
        return SUCCESS;
    }
    
    protected var _value :MutableValue;
}
}
