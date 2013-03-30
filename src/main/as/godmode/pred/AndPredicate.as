//
// godmode

package godmode.pred {

import godmode.core.BehaviorTask;
import godmode.core.BehaviorTaskContainer;

public class AndPredicate extends BehaviorPredicate
    implements BehaviorTaskContainer
{
    public function AndPredicate (preds :Vector.<BehaviorPredicate> = null) {
        _preds = (preds || new Vector.<BehaviorPredicate>());
    }

    public function addPred (pred :BehaviorPredicate) :void {
        _preds.push(pred);
    }

    public function get children () :Vector.<BehaviorTask> {
        return Vector.<BehaviorTask>(_preds);
    }

    override public function evaluate () :Boolean {
        for each (var pred :BehaviorPredicate in _preds) {
            if (!pred.evaluate()) {
                return false;
            }
        }
        return true;
    }

    protected var _preds :Vector.<BehaviorPredicate>;
}
}

