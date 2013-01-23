//
// godmode

package godmode.core {

/** A Task that calls a function. */
public class FunctionTask extends Task
{
    public function FunctionTask (name :String, f :Function) {
        super(name);
        _f = f;
    }
    
    override protected function update (dt :Number) :int {
        var val :* = _f();
        return (val is int ? val as int : SUCCESS);
    }
    
    protected var _f :Function;
}
}
