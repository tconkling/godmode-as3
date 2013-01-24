//
// godmode

package godmode.core {

/** Implemented by BehaviorTasks that contain other BehaviorTasks */
public interface BehaviorTaskContainer
{
    function get children () :Vector.<BehaviorTask>;
}
}
