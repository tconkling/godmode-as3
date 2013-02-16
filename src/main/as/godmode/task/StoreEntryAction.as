//
// godmode

package godmode.task {

import godmode.core.BehaviorTask;
import godmode.data.MutableEntry;

public class StoreEntryAction extends BehaviorTask
{
    public function StoreEntryAction (value :MutableEntry, storeVal :*) {
        _value = value;
        _storeVal = storeVal;
    }

    override protected function updateTask (dt :Number) :int {
        _value.store(_storeVal);
        return SUCCESS;
    }

    protected var _value :MutableEntry;
    protected var _storeVal :*;
}
}
