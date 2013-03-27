//
// godmode

package godmode.task {

import godmode.core.BehaviorTask;

/** A Task that does nothing */
public class NoOpTask extends BehaviorTask
{
    public static const SUCCESS :NoOpTask = new NoOpTask(BehaviorTask.SUCCESS);
    public static const FAIL :NoOpTask = new NoOpTask(BehaviorTask.FAIL);

    public function NoOpTask (status :int) {
        _status = status;
    }

    override protected function updateTask (dt :Number) :int {
        return _status;
    }

    protected var _status :int;
}
}
