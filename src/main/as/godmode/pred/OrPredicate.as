//
// godmode

package godmode.pred {

import godmode.core.BehaviorTask;
import godmode.core.BehaviorTaskContainer;

public class OrPredicate extends Predicate
    implements BehaviorTaskContainer
{
    public function OrPredicate (preds :Vector.<Predicate> = null) {
        _preds = (preds || new <Predicate>[]);
    }

    public function addPred (pred :Predicate) :void {
        _preds.push(pred);
    }

    public function get children () :Vector.<BehaviorTask> {
        return Vector.<BehaviorTask>(_preds);
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

