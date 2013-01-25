//
// godmode

package godmode.task {

import godmode.core.StatefulBehaviorTask;
import godmode.data.Value;

/** A Task that completes after a specified amount of time */
public class TimerAction extends StatefulBehaviorTask
{
    public function TimerAction (time :Value) {
        _time = time;
        reset();
    }
    
    override protected function reset () :void {
        _thisTime = -1;
    }
    
    override protected function updateTask (dt :Number) :int {
        if (_thisTime < 0) {
            _thisTime = Math.max(_time.value, 0);
            _elapsedTime = 0;
        }
        _elapsedTime += dt;
        return (_elapsedTime >= _thisTime ? SUCCESS : RUNNING);
    }
    
    protected var _time :Value;
    protected var _thisTime :Number;
    protected var _elapsedTime :Number;
}
}
