//
// godmode

package godmode.data {

public interface MutableEntry extends Entry
{
    function store (value :*) :void;
    function remove () :void;
}
}
