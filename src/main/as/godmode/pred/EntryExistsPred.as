//
// godmode

package godmode.pred {

import godmode.data.Entry;

public class EntryExistsPred extends Predicate
{
    public function EntryExistsPred (entry :Entry) {
        _entry = entry;
    }
    
    override public function evaluate () :Boolean {
        return _entry.exists;
    }
    
    protected var _entry :Entry;
}
}
