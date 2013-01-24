//
// godmode

package godmode.pred {

import godmode.core.Task;
import godmode.core.TaskContainer;

public class OrPredicate extends Predicate
    implements TaskContainer
{
    public function OrPredicate (name :String, preds :Vector.<Predicate>) {
        super(name);
        _preds = preds;
    }
    
    public function get children () :Vector.<Task> {
        return Vector.<Task>(_preds);
    }
    
    override public function evaluate () :Boolean {
        for each (var pred :Predicate in _preds) {
            if (pred.evaluate()) {
                return true;
            }
        }
        return false;
    }
    
    protected var _preds :Vector.<Predicate>;
}
}

