//
// godmode

package godmode.pred {

import godmode.core.BehaviorTask;
import godmode.core.BehaviorTaskContainer;

public class NotPredicate extends BehaviorPredicate
    implements BehaviorTaskContainer
{
    public function NotPredicate (pred :BehaviorPredicate) {
        _pred = pred;
    }

    public function get pred () :BehaviorPredicate {
        return _pred;
    }

    public function get children () :Vector.<BehaviorTask> {
        return new <BehaviorTask>[ _pred ];
    }

    override public function evaluate () :Boolean {
        return !_pred.evaluate();
    }

    protected var _pred :BehaviorPredicate;
}
}
