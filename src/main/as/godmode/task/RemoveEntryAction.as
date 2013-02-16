//
// godmode

package godmode.task {

import godmode.core.BehaviorTask;
import godmode.data.MutableEntry;

public class RemoveEntryAction extends BehaviorTask
{
    public function RemoveEntryAction (entry :MutableEntry) {
        _entry = entry;
    }
    
    override protected function updateTask (dt :Number) :int {
        _entry.remove();
        return SUCCESS;
    }
    
    protected var _entry :MutableEntry;
}
}
