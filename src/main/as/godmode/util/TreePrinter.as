//
// godmode

package godmode.util {

import godmode.core.Task;
import godmode.core.TaskContainer;

/**
 * Generates a string description of a behavior task tree.
 */
public class TreePrinter
{
    public function TreePrinter (root :Task) {
        _root = root;
    }
    
    public function toString () :String {
        return visit(_root, 0);
    }
    
    protected function visit (task :Task, depth :int) :String {
        var out :String = "";
        if (depth > 0) {
            out += "\n";
            for (var ii :int = 0; ii < depth; ++ii) {
                out += "- ";
            }
        }
        
        out += "[" + task.description + "]:" + statusName(task.status);
        
        if (task is TaskContainer) {
            var tc :TaskContainer = TaskContainer(task);
            for each (var child :Task in tc.children) {
                out += visit(child, depth + 1);
            }
        }
        
        return out;
    }
    
    protected static function statusName (status :int) :String {
        switch (status) {
        case Task.RUNNING: return "RUNNING";
        case Task.SUCCESS: return "SUCCESS";
        case Task.FAIL: return "FAIL";
        default: return "NEVER_RUN";
        }
    }
    
    protected var _root :Task;
}
}
