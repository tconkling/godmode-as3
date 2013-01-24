//
// godmode

package godmode.selector {

import godmode.core.Task;

public class WeightedTask
{
    public function WeightedTask (task :Task, weight :Number) {
        this.task = task;
        this.weight = weight;
    }
    
    internal var task :Task;
    internal var weight :Number;
    internal var skip :Boolean;
    internal var hasRun :Boolean;
}
}
