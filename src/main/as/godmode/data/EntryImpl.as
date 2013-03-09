//
// godmode

package godmode.data {

internal class EntryImpl
    implements MutableEntry
{
    public function EntryImpl (bb :Blackboard) {
        _bb = bb;
    }

    public function get exists () :Boolean {
        return (this.value != null);
    }

    public function get value () :* {
        return _bb.fromBlackboard(_value);
    }

    public function store (val :Object) :void {
        if (val == null) {
            throw new Error("Cannot store null in a blackboard");
        }
        _value = _bb.toBlackboard(val);
    }

    public function remove () :void {
        _value = undefined;
    }

    protected var _bb :Blackboard;
    protected var _value :*;
}

}
