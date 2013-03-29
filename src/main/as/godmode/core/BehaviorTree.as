//
// godmode

package godmode.core {

public class BehaviorTree
{
    /**
     * If true, the tree will generate a human readable String describing the state of the tree.
     * This is slow, and should not be used in production code.
     */
    public var debug :Boolean;
    /** If both this and debug are true, the tree status will be printed to the console every update. */
    public var debugPrint :Boolean;

    public function BehaviorTree (root :BehaviorTask) {
        _root = root;
    }

    /** If 'debug' is true, returns the status of the tree as of the last update */
    public function get treeStatus () :String {
        return _lastTreeStatus;
    }

    /** Updates the tree */
    public function update (dt :Number) :void {
        // If we're in debug mode
        if (debug) {
            clearStatus(_root);
        }

        _root.update(dt);

        if (debug) {
            _lastTreeStatus = getStatusString(_root, 0);
            if (debugPrint) {
                trace(_lastTreeStatus);
            }
        }
    }

    protected function clearStatus (task :BehaviorTask) :void {
        task._lastStatus = 0;
        if (task is BehaviorTaskContainer) {
            var tc :BehaviorTaskContainer = BehaviorTaskContainer(task);
            for each (var child :BehaviorTask in tc.children) {
                clearStatus(child);
            }
        }
    }

    protected function getStatusString (task :BehaviorTask, depth :int) :String {
        var out :String = "";
        if (depth > 0) {
            out += "\n";
            for (var ii :int = 0; ii < depth; ++ii) {
                out += "- ";
            }
        }

        out += "[" + task.description + "]:" + statusName(task._lastStatus);

        if (task is BehaviorTaskContainer) {
            var tc :BehaviorTaskContainer = BehaviorTaskContainer(task);
            for each (var child :BehaviorTask in tc.children) {
                out += getStatusString(child, depth + 1);
            }
        }

        return out;
    }

    protected static function statusName (status :int) :String {
        switch (status) {
        case BehaviorTask.RUNNING: return "RUNNING";
        case BehaviorTask.SUCCESS: return "SUCCESS";
        case BehaviorTask.FAIL: return "FAIL";
        default: return "INACTIVE";
        }
    }

    protected var _root :BehaviorTask;
    protected var _lastTreeStatus :String;
}
}
