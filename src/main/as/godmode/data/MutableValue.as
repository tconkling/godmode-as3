//
// godmode

package godmode.data {

public interface MutableValue extends Value
{
    function store (value :*) :void;
    function remove () :void;
}
}
