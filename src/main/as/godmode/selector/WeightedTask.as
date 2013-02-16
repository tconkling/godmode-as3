//
// godmode

package godmode.selector {

import godmode.core.BehaviorTask;

public class WeightedTask
{
    public function WeightedTask (task :BehaviorTask, weight :Number) {
        this.task = task;
        this.weight = weight;
    }

    internal var task :BehaviorTask;
    internal var weight :Number;
    internal var skip :Boolean;
    internal var hasRun :Boolean;
}
}
