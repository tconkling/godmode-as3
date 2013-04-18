//
// godmode

package godmode.core {

/** Used with ScopeDecorator to allow execution of logic when a task is entered and exited */
public interface ScopedResource
{
    /** Called when the scope is entered. Modify state/acquire resources/etc */
    function acquire () :void;

    /** Called when the scope is exited. Restore state/release resources/etc */
    function release () :void;
}
}
