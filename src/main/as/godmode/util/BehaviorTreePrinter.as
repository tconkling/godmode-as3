//
// godmode

package godmode.util {

import godmode.core.BehaviorTask;
import godmode.core.BehaviorTaskContainer;

/**
 * Generates a string description of a behavior tree.
 */
public class BehaviorTreePrinter
{
    public function BehaviorTreePrinter (root :BehaviorTask) {
        _root = root;
    }
    
    public function toString () :String {
        return visit(_root, 0);
    }
    
    protected function visit (task :BehaviorTask, depth :int) :String {
        var out :String = "";
        if (depth > 0) {
            out += "\n";
            for (var ii :int = 0; ii < depth; ++ii) {
                out += "- ";
            }
        }
        
        out += "[" + task.description + "]:" + statusName(task.status);
        
        if (task is BehaviorTaskContainer) {
            var tc :BehaviorTaskContainer = BehaviorTaskContainer(task);
            for each (var child :BehaviorTask in tc.children) {
                out += visit(child, depth + 1);
            }
        }
        
        return out;
    }
    
    protected static function statusName (status :int) :String {
        switch (status) {
        case BehaviorTask.RUNNING: return "RUNNING";
        case BehaviorTask.SUCCESS: return "SUCCESS";
        case BehaviorTask.FAIL: return "FAIL";
        default: return "NEVER_RUN";
        }
    }
    
    protected var _root :BehaviorTask;
}
}
