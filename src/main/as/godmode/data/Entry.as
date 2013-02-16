//
// godmode

package godmode.data {

public interface Entry
{
    /** @return true if the entry exists in the blackboard */
    function get exists () :Boolean;

    /** @return the value stored in the blackboard for this entry */
    function get value () :*;
}
}
