//
// godmode

package godmode.data {

public interface MutableEntry extends Entry
{
    /** Stores a value for this Entry. Values cannot be null. */
    function store (value :Object) :void;

    /** Removes this Entry's value */
    function remove () :void;
}
}
