//
// godmode

package godmode.core {

import flash.utils.getQualifiedClassName;

public class BehaviorTask
{
    public static const RUNNING :int = 1;
    public static const SUCCESS :int = 2;
    public static const FAIL :int = 3;
    
    public function BehaviorTask (name :String = null) {
        _name = name;
    }
    
    /**
     * Updates the behavior tree.
     *
     * Subclasses do not override this function; instead they should override updateTask()
     */
    public final function update (dt :Number) :int {
        return updateInternal(dt);
    }
    
    /**
     * Deactivates the task. External code should call this to dispose of the task tree.
     *
     * BehaviorTaskContainers should deactivate any active child tasks in their reset() function.
     */
    public final function deactivate () :void {
        deactivateInternal();
    }
    
    /** Creates a human-readable string describing the current state of the behavior tree */
    public final function getTreeStateString () :String {
        return new TreePrinter(this).toString();
    }
    
    
    /** Returns a description of the task. Subclasses can optionally override. */
    public function get description () :String {
        var out :String = className(this);
        if (_name != null) {
            out = '"' + _name + '" ' + out;
        }
        return out;
    }
    
    /** Subclasses should override this to perform update logic. */
    protected function updateTask (dt :Number) :int {
        return SUCCESS;
    }
    
    protected static function className (obj :Object) :String {
        var s :String = getQualifiedClassName(obj).replace("::", ".");
        var dex :int = s.lastIndexOf(".");
        return s.substring(dex + 1); // works even if dex is -1
    }
    
    internal function updateInternal (dt :Number) :int {
        _lastStatus = updateTask(dt);
        return _lastStatus;
    }
    
    internal function deactivateInternal () :void {
    }
    
    internal final function get status () :int {
        return _lastStatus;
    }
    
    protected var _name :String;
    protected var _lastStatus :int;
}
}
