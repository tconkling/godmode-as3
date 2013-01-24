//
// godmode

package godmode.pred {

public class FunctionPredicate extends Predicate
{
    public function FunctionPredicate (name :String, f :Function) {
        super(name);
        _f = f;
    }
    
    override public function evaluate () :Boolean {
        return _f();
    }
    
    protected var _f :Function;
}
}
