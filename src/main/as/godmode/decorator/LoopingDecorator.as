//
// godmode

package godmode.decorator {

import godmode.core.StatefulBehaviorTask;
import godmode.core.BehaviorTask;
import godmode.core.BehaviorTaskContainer;

public class LoopingDecorator extends StatefulBehaviorTask
    implements BehaviorTaskContainer
{
    public static const BREAK_NEVER :int = 0;
    public static const BREAK_ON_SUCCESS :int = 1;
    public static const BREAK_ON_FAIL :int = 2;
    
    public function LoopingDecorator(type :int, loopCount :int, task :BehaviorTask) {
        _task = task;
        _type = type;
        _targetLoopCount = loopCount;
    }
    
    public function get children () :Vector.<BehaviorTask> {
        return new <BehaviorTask>[ _task ];
    }
    
    override public function get description () :String {
        return super.description + " " + typeName(_type);
    }
    
    override protected function reset () :void {
        _curLoopCount = 0;
        _task.deactivate();
    }
    
    override protected function updateTask (dt :Number) :int {
        var status :int = _task.update(dt);
        if (status == RUNNING) {
            return RUNNING;
        }
        
        if ((_type == BREAK_ON_SUCCESS && status == SUCCESS) ||
            (_type == BREAK_ON_FAIL && status == FAIL)) {
            // break condition met
            return status;
        } else if (_targetLoopCount > 0 && ++_curLoopCount >= _targetLoopCount) {
            // hit the loop count
            return SUCCESS;
        } else {
            return RUNNING;
        }
    }
    
    protected static function typeName (type :int) :String {
        switch (type) {
        case BREAK_NEVER: return "BREAK_NEVER";
        case BREAK_ON_SUCCESS: return "BREAK_ON_SUCCESS";
        case BREAK_ON_FAIL: return "BREAK_ON_FAIL";
        }
        throw new Error("Unrecognized type: " + type);
    }
    
    protected var _task :BehaviorTask;
    protected var _type :int;
    protected var _targetLoopCount :int;
    
    protected var _curLoopCount :int;
}
}
