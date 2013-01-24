//
// godmode

package godmode.core {
import flash.utils.getQualifiedClassName;

import godmode.util.TreePrinter;

public class Task
{
    public static const RUNNING :int = 1;
    public static const SUCCESS :int = 2;
    public static const FAIL :int = 3;
    
    public function Task (name :String = null) {
        _name = name;
    }
    
    /**
     * Updates the task.
     * Subclasses do not override this function; instead they should override update()
     */
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
    
    public final function get status () :int {
        return _lastStatus;
    }
    
    public final function getTreeStateString () :String {
        return new TreePrinter(this).toString();
    }
    
    /** Returns a description of the task */
    public function get description () :String {
        var out :String = className(this);
        if (_name != null) {
            out = '"' + _name + '" ' + out;
        }
        return out;
    }
    
    /** Subclasses override */
    protected function update (dt :Number) :int {
        return SUCCESS;
    }
    
    protected static function className (obj :Object) :String {
        var s :String = getQualifiedClassName(obj).replace("::", ".");
        var dex :int = s.lastIndexOf(".");
        return s.substring(dex + 1); // works even if dex is -1
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
