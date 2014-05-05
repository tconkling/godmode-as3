//
// godmode

package godmode.selector {

import godmode.core.BehaviorTask;
import godmode.core.BehaviorTaskContainer;
import godmode.core.RandomStream;
import godmode.core.StatefulBehaviorTask;
import godmode.util.Randoms;

/**
 * A selector that chooses which task to run at random.
 * Each task has a "weight" associated with it that determines how likely it is to be selected
 * relative to the other tasks in the selector. (If all tasks have the same weight, the selection
 * is entirely random.)
 */
public class WeightedSelector extends StatefulBehaviorTask
    implements BehaviorTaskContainer
{
    public function WeightedSelector (rng :RandomStream, tasks :Vector.<WeightedTask> = null) {
        _rands = new Randoms(rng);
        _children = (tasks || new Vector.<WeightedTask>());
    }

    public function addTask (task :WeightedTask) :void {
        _children.push(task);
    }

    public function get children () :Vector.<BehaviorTask> {
        const n :uint = _children.length;
        var out :Vector.<BehaviorTask> = new Vector.<BehaviorTask>(n, true);
        for (var ii :int = 0; ii < n; ++ii) {
            out[ii] = _children[ii].task;
        }
        return out;
    }

    override protected function reset () :void {
        if (_curChild != null) {
            _curChild.task.deactivate();
            _curChild = null;
        }
    }

    override protected function updateTask (dt :Number) :int {
        // Are we already running a task?
        var status :int;
        if (_curChild != null) {
            status = _curChild.task.update(dt);

            // The task completed
            if (status != RUNNING) {
                _curChild = null;
            }

            // Exit immediately, unless our task failed, in which case we'll try to select
            // another one below
            if (status != FAIL) {
                return status;
            }
        }

        var numTriedTasks :int = 0;
        while (numTriedTasks < _children.length) {
            var child :WeightedTask = chooseNextChild();
            numTriedTasks++;
            // skip this task on our next call to chooseNextChild
            child.skip = true;

            status = child.task.update(dt);
            if (status == RUNNING) {
                _curChild = child;
            }

            // Exit immediately, unless our task failed, in which case we'll try to select
            // another one
            if (status != FAIL) {
                resetSkippedStatus();
                return status;
            }
        }

        resetSkippedStatus();

        // all of our tasks failed
        return FAIL;
    }

    protected function chooseNextChild () :WeightedTask {
        var pick :WeightedTask = null;
        var total :Number = 0;
        for each (var child :WeightedTask in _children) {
            if (!child.skip) {
                total += child.weight;
                if (pick == null || _rands.getNumber(total) < child.weight) {
                    pick = child;
                }
            }
        }
        return pick;
    }

    protected function resetSkippedStatus () :void {
        for each (var child :WeightedTask in _children) {
            child.skip = false;
        }
    }

    protected var _rands :Randoms;
    protected var _children :Vector.<WeightedTask>;
    protected var _curChild :WeightedTask;
}
}
