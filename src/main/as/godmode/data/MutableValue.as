//
// godmode

package godmode.data {

public interface MutableValue extends Value
{
    function setValue (val :*) :void;
    function removeValue () :void;
}
}
