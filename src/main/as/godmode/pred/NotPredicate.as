//
// godmode

package godmode.pred {

import godmode.core.Task;
import godmode.core.TaskContainer;

public class NotPredicate extends Predicate
    implements TaskContainer
{
    public function NotPredicate (name :String, pred :Predicate) {
        super(name);
        _pred = pred;
    }
    
    public function get children () :Vector.<Task> {
        return new <Task>[ _pred ];
    }
    
    override public function evaluate () :Boolean {
        return !_pred.evaluate();
    }
    
    protected var _pred :Predicate;
}
}
