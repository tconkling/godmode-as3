//
// godmode

package godmode.selector {

import godmode.core.BehaviorTask;
import godmode.core.BehaviorTaskContainer;
import godmode.core.StatefulBehaviorTask;

/**
 * A selector that updates all children, every update, until a condition is met.
 */
public class ParallelSelector extends StatefulBehaviorTask
    implements BehaviorTaskContainer
{
    public static const ALL_SUCCESS :int = 0;   // SUCCESS if all succeed. FAIL if any fail.
    public static const ANY_SUCCESS :int = 1;   // SUCCESS if any succeed. FAIL if all fail.
    public static const ALL_FAIL :int = 2;      // SUCCESS if all fail. FAIL if any succeed.
    public static const ANY_FAIL :int = 3;      // SUCCESS if any fail. FAIL if all succeed.
    public static const ALL_COMPLETE :int = 4;  // SUCCESS when all succeed or fail.
    public static const ANY_COMPLETE :int = 5;  // SUCCESS when any succeed or fail.

    public function ParallelSelector (type :int, tasks :Vector.<BehaviorTask> = null) {
        _type = type;
        _children = (tasks || new Vector.<BehaviorTask>());
    }

    public function get children () :Vector.<BehaviorTask> {
        return _children;
    }

    public function get type () :int {
        return _type;
    }

    override public function get description () :String {
        return super.description + ":" + typeName(_type);
    }

    public function addTask (task :BehaviorTask) :void {
        _children.push(task);
    }

    override protected function reset () :void {
        for each (var task :BehaviorTask in _children) {
            task.deactivate();
        }
    }

    override protected function updateTask (dt :Number) :int {
        var runningChildren :Boolean = false;
        for each (var child :BehaviorTask in _children) {
            var childStatus :int = child.update(dt);
            if (childStatus == SUCCESS) {
                if (_type == ANY_SUCCESS || _type == ANY_COMPLETE) {
                    return SUCCESS;
                } else if (_type == ALL_FAIL) {
                    return FAIL;
                }

            } else if (childStatus == FAIL) {
                if (_type == ANY_FAIL || _type == ANY_COMPLETE) {
                    return SUCCESS;
                } else if (_type == ALL_SUCCESS) {
                    return FAIL;
                }

            } else {
                runningChildren = true;
            }
        }

        return (runningChildren ? RUNNING : SUCCESS);
    }

    protected static function typeName (type :int) :String {
        switch (type) {
        case ALL_SUCCESS: return "ALL_SUCCESS";
        case ANY_SUCCESS: return "ANY_SUCCESS";
        case ALL_FAIL: return "ALL_FAIL";
        case ANY_FAIL: return "ANY_FAIL";
        case ALL_COMPLETE: return "ALL_COMPLETE";
        case ANY_COMPLETE: return "ANY_COMPLETE";
        }
        throw new Error("Unrecognized type " + type);
    }

    protected var _type :int;
    protected var _children :Vector.<BehaviorTask>;
}
}
