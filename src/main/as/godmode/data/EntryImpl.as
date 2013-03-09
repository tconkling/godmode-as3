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
        _value = (val != null ? _bb.toBlackboard(val) : null);
    }

    public function remove () :void {
        store(null);
    }

    protected var _bb :Blackboard;
    protected var _value :Object;
}

}
