//
// godmode

package godmode.task {

import godmode.core.BehaviorTask;
import godmode.data.MutableEntry;

public class RemoveEntryTask extends BehaviorTask
{
    public function RemoveEntryTask (entry :MutableEntry) {
        _entry = entry;
    }
    
    override protected function updateTask (dt :Number) :int {
        _entry.remove();
        return SUCCESS;
    }
    
    protected var _entry :MutableEntry;
}
}
