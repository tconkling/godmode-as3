//
// godmode

package godmode.pred {

import godmode.data.Value;

public class ValueExistsPred extends Predicate
{
    public function ValueExistsPred (name :String, value :Value) {
        super(name);
        _value = value;
    }
    
    override public function evaluate () :Boolean {
        return _value.exists;
    }
    
    protected var _value :Value;
}
}
