//
// godmode

package godmode.core {

public class Task
{
    public static const RUNNING :int = 1;
    public static const SUCCESS :int = 2;
    public static const FAIL :int = 3;
    
    public function Task (name :String = null) {
        _name = name;
    }
    
    /** Updates the task */
    public final function updateTask (dt :Number) :int {
        return updateInternal(dt);
    }
    
    /**
     * Deactivates the task. This is only necessary to call if the task is being
     * deactivated prematurely - tasks will be automatically deactivated when they return
     * a non-RUNNING status value from an update.
     */
    public final function deactivate () :void {
        deactivateInternal();
    }
    
    /** Subclasses override */
    protected function update (dt :Number) :int {
        return SUCCESS;
    }
    
    internal function updateInternal (dt :Number) :int {
        _lastStatus = update(dt);
        return _lastStatus;
    }
    
    internal function deactivateInternal () :void {
    }
    
    protected var _name :String;
    protected var _lastStatus :int;
}
}
