//
// godmode

package godmode.data {

import flash.utils.Dictionary;

/**
 * Shared data storage for BehaviorTasks. A Blackboard represents an entity's "body of knowledge".
 * (Entities might employ multiple Blackboards - eg, a squad made up of multiple entities might
 * have "squad knowledge" stored in a Blackboard shared across the squad.)
 *
 * Entity-specific tasks can use a Blackboard directly, but it may be more useful for generic
 * tasks to operate on "value accessors", which expose a single blackboard value, and are
 * created with "getAccessor()" function.
 */
public class Blackboard
{
    /** Creates an accessor for the given key in the blackboard. */
    public function getAccessor (key :String, type :Class, defaultVal :* = undefined) :MutableValue {
        return new BlackboardAccessor(this, key, type, defaultVal);
    }
    
    /** @return true if a value with the given key is in the blackboard */
    public function contains (key :String) :Boolean {
        return (key in _dict);
    }
    
    /** Removes the value with the given key from the blackboard (if the key exists) */
    public function remove (key :String) :void {
        delete _dict[key];
    }
    
    /** Stores a value in the blackboard, with the given key. The value must not be null. */
    public function store (key :String, val :*) :void {
        if (val == null) {
            throw new Error("cannot store null in a blackboard");
        }
        _dict[key] = val;
    }
    
    /**
     * @return the value stored in the blackboard for the given key
     * (or null/undefined if the key does not exist).
     */
    public function retrieve (key :String, type :Class, defaultVal :* = undefined) :* {
        var val :* = _dict[key];
        return (val is type ? val : defaultVal);
    }
    
    protected var _dict :Dictionary = new Dictionary();
}
}

import godmode.data.Blackboard;
import godmode.data.MutableValue;

class BlackboardAccessor
    implements MutableValue
{
    public function BlackboardAccessor (bb :Blackboard, key :String, type :Class, defaultVal :*) {
        _bb = bb;
        _key = key;
        _type = type;
        _defaultVal = defaultVal;
    }
    
    public function get exists () :Boolean {
        return _bb.contains(_key);
    }
    
    public function get value () :* {
        return _bb.retrieve(_key, _type, _defaultVal);
    }
    
    public function store (val :*) :void {
        _bb.store(_key, val);
    }
    
    public function remove () :void {
        _bb.remove(_key);
    }
    
    protected var _bb :Blackboard;
    protected var _key :String;
    protected var _type :Class;
    protected var _defaultVal :*;
}


