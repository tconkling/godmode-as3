//
// godmode

package godmode.data {

import flash.utils.Dictionary;

/**
 * Shared data storage for BehaviorTasks. A Blackboard represents an entity's "body of knowledge".
 * (Entities might employ multiple Blackboards - eg, a squad made up of multiple entities might
 * have "squad knowledge" stored in a Blackboard shared across the squad.)
 *
 * Blackboard data is accessed and manipulated through Entry objects, which can be passed directly
 * to tasks - allowing tasks to be defined more generally, rather than having them operate on
 * specific named data.
 */
public class Blackboard
{
    /** Returns a key-less Entry that holds an immutable value */
    public static function staticEntry (value :Object) :Entry {
        return new StaticEntry(value);
    }

    /** Returns the entry accessor for the given key in the blackboard */
    public function getEntry (key :String) :MutableEntry {
        var entry :EntryImpl = _dict[key];
        if (entry == null) {
            entry = new EntryImpl(this);
            _dict[key] = entry;
        }
        return entry;
    }

    /** @return true if a value with the given key is in the blackboard */
    public function contains (key :String) :Boolean {
        var entry :EntryImpl = _dict[key];
        return (entry != null && entry.exists);
    }

    /** Subclasses can override to transform values before they're stored in the blackboard */
    public function toBlackboard (val :*) :* {
        return val;
    }

    /** Subclasses can override to transform values before they're returned fromthe blackboard */
    public function fromBlackboard (val :*) :* {
        return val;
    }

    protected var _dict :Dictionary = new Dictionary();
}
}

import godmode.data.Entry;

class StaticEntry
    implements Entry
{
    public function StaticEntry (value :Object) {
        _value = value;
    }

    public function get value () :* {
        return _value;
    }

    public function get exists () :Boolean {
        return true;
    }

    protected var _value :Object;
}


