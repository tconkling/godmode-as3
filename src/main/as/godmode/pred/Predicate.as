//
// godmode

package godmode.pred {

import godmode.core.BehaviorTask;

/** A Task that only returns SUCCESS or FAIL */
public class Predicate extends BehaviorTask
{
    /** A Predicate that always evaluates to true */
    public static function get TRUE () :Predicate {
        if (_true == null) {
            _true = new ConstPredicate(true);
        }
        return _true;
    }

    /** A Predicate that always evaluates to false */
    public static function get FALSE () :Predicate {
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

    protected static var _true :Predicate;
    protected static var _false :Predicate;
}
}

import godmode.pred.Predicate;

class ConstPredicate extends Predicate {
    public function ConstPredicate (value :Boolean) {
        _value = value;
    }

    override public function evaluate () :Boolean {
        return _value;
    }

    protected var _value :Boolean;
}
