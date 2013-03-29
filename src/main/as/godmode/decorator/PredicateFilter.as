//
// godmode

package godmode.decorator {

import godmode.core.StatefulBehaviorTask;
import godmode.core.BehaviorTask;
import godmode.core.BehaviorTaskContainer;
import godmode.pred.BehaviorPredicate;

/** A filter that runs its task if the given predicate succeeds */
public class PredicateFilter extends StatefulBehaviorTask
    implements BehaviorTaskContainer
{
    public function PredicateFilter (pred :BehaviorPredicate, task :BehaviorTask) {
        _pred = pred;
        _task = task;
    }

    public function get children () :Vector.<BehaviorTask> {
        return new <BehaviorTask>[ _pred, _task ];
    }

    override protected function reset () :void {
        _task.deactivate();
    }

    override protected function updateTask (dt :Number) :int {
        // call _pred.updateTask so that the pred's _lastStatus gets set
        if (_pred.update(dt) != SUCCESS) {
            return FAIL;
        }
        return _task.update(dt);
    }

    protected var _pred :BehaviorPredicate;
    protected var _task :BehaviorTask;
}
}
