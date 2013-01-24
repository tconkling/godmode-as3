//
// godmode

package godmode.data {

public interface Value
{
    /** @return true if the value exists in the blackboard */
    function get exists () :Boolean;
    
    /** @return the value stored in the blackboard */
    function get value () :*;
}
}
