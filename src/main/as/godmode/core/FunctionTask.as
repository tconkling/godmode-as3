//
// godmode

package godmode.core {

/**
 * A BehaviorTask that calls a function.
 * The function can optionally take a single 'Number' parameter (the time delta for this task)
 * The function can optionally return a Task status. If it does not, a status of SUCCESS will
 * be assumed.
 */
public class FunctionTask extends BehaviorTask
{
    public function FunctionTask (name :String, f :Function) {
        super(name);
        _f = f;
    }
    
    override protected function update (dt :Number) :int {
        var val :* = (_f.length == 1 ? _f(dt) : _f());
        return (val is int ? val as int : SUCCESS);
    }
    
    protected var _f :Function;
}
}
