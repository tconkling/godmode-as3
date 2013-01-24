//
// godmode

package godmode.core {

public interface MutableValue extends Value
{
    function setValue (val :*) :void;
    function removeValue () :void;
}
}
