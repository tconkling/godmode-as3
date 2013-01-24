//
// godmode

package godmode.action {

import godmode.core.StatefulTask;

/** A Task that completes after a specified amount of time */
public class TimerAction extends StatefulTask
{
    public function TimerAction (name :String, time :Number) {
        _totalTime = time;
        _elapsedTime = 0;
    }
    
    override protected function reset () :void {
        _elapsedTime = 0;
    }
    
    override protected function update (dt :Number) :int {
        _elapsedTime += dt;
        return (_elapsedTime >= _totalTime ? SUCCESS : RUNNING);
    }
    
    protected var _totalTime :Number;
    protected var _elapsedTime :Number;
}
}
