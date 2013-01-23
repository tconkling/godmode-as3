//
// godmode

package godmode.core {

/**
 * Base class for Tasks with state.
 * StatefulTasks can have activation and deactivation logic.
 */
public class StatefulTask extends Task
{
    public function StatefulTask (name :String = null) {
        super(name);
    }
    
    /**
     * Subclasses can override this to reset any state associated with the task.
     * reset() is called whenever the task stops running, either as a result of
     * an update, or by being deactivated.
     */
    protected function reset () :void {
    }
    
    override internal function updateInternal (dt :Number) :int {
        _lastStatus = update(dt);
        _running = (_lastStatus == RUNNING);
        if (!_running) {
            reset();
        }
        
        return _lastStatus;
    }
    
    override internal function deactivateInternal () :void {
        if (_running) {
            _running = false;
            reset();
        }
    }
    
    private var _running :Boolean;
}
}
