//
// godmode

package godmode.data {

public interface MutableEntry extends Entry
{
    /** Stores a value for this Entry. Null values are considered removed. */
    function store (value :Object) :void;

    /** Equivalent to store(null) */
    function remove () :void;
}
}
