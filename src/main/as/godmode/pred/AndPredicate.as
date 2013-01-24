//
// godmode

package godmode.pred {

import godmode.core.Task;
import godmode.core.TaskContainer;

public class AndPredicate extends Predicate
    implements TaskContainer
{
    public function AndPredicate (name :String, preds :Vector.<Predicate>) {
        super(name);
        _preds = preds;
    }
    
    public function get children () :Vector.<Task> {
        return Vector.<Task>(_preds);
    }
    
    override public function evaluate () :Boolean {
        for each (var pred :Predicate in _preds) {
            if (!pred.evaluate()) {
                return false;
            }
        }
        return true;
    }
    
    protected var _preds :Vector.<Predicate>;
}
}

