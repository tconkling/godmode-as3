//
// godmode

package godmode.core {

/** Implemented by Tasks that contain other Tasks */
public interface TaskContainer
{
    function get children () :Vector.<Task>;
}
}
