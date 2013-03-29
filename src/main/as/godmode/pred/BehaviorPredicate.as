//
// godmode

package godmode.pred {

import godmode.core.BehaviorTask;

/** A Task that only returns SUCCESS or FAIL */
public class BehaviorPredicate extends BehaviorTask
{
    /** A Predicate that always evaluates to true */
    public static function get TRUE () :BehaviorPredicate {
        if (_true == null) {
            _true = new ConstPredicate(true);
        }
        return _true;
    }

    /** A Predicate that always evaluates to false */
    public static function get FALSE () :BehaviorPredicate {
        if (_false == null) {
            _false = new ConstPredicate(false);
        }
        return _false;
    }

    // Subclasses must implement
    public function evaluate () :Boolean {
        throw new Error("not implemented");
    }

    override final protected function updateTask (dt :Number) :int {
        return (evaluate() ? SUCCESS : FAIL);
    }

    protected static var _true :BehaviorPredicate;
    protected static var _false :BehaviorPredicate;
}
}

import godmode.pred.BehaviorPredicate;

class ConstPredicate extends BehaviorPredicate {
    public function ConstPredicate (value :Boolean) {
        _value = value;
    }

    override public function evaluate () :Boolean {
        return _value;
    }

    protected var _value :Boolean;
}
