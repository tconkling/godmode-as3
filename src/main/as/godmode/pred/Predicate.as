//
// godmode

package godmode.pred {

import godmode.core.BehaviorTask;

/** A Task that only returns SUCCESS or FAIL */
public class Predicate extends BehaviorTask
{
    // Subclasses must implement
    public function evaluate () :Boolean {
        throw new Error("not implemented");
    }
    
    override final protected function updateTask (dt :Number) :int {
        return (evaluate() ? SUCCESS : FAIL);
    }
}
}
