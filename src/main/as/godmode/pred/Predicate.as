//
// godmode

package godmode.pred {

import godmode.core.Task;

/** A Task that only returns SUCCESS or FAIL */
public class Predicate extends Task
{
    public function Predicate (name :String = null) {
        super(name);
    }
    
    // Subclasses must implement
    public function evaluate () :Boolean {
        throw new Error("not implemented");
    }
    
    override final protected function update (dt :Number) :int {
        return (evaluate() ? SUCCESS : FAIL);
    }
}
}
