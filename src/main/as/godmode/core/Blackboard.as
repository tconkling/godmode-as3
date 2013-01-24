//
// godmode

package godmode.core {

import flash.utils.Dictionary;

public class Blackboard
{
    /** Creates an accessor for the given key in the blackboard. */
    public function accessorFor (key :String, type :Class, defaultVal :* = undefined) :MutableValue {
        return new BlackboardAccessor(this, key, type, defaultVal);
    }
    
    public function containsKey (key :String) :Boolean {
        return (key in _dict);
    }
    
    public function removeKey (key :String) :void {
        delete _dict[key];
    }
    
    public function setValue (key :String, val :*) :void {
        _dict[key] = val;
    }
    
    public function getValue (key :String, type :Class, defaultVal :* = undefined) :* {
        var val :* = _dict[key];
        return (val is type ? val : defaultVal);
    }
    
    protected var _dict :Dictionary = new Dictionary();
}
}

import godmode.core.Blackboard;
import godmode.core.MutableValue;

class BlackboardAccessor
    implements MutableValue
{
    public function BlackboardAccessor (bb :Blackboard, key :String, type :Class, defaultVal :*) {
        _bb = bb;
        _key = key;
        _type = type;
        _defaultVal = defaultVal;
    }
    
    public function getValue () :* {
        return _bb.getValue(_key, _type, _defaultVal);
    }
    
    public function setValue (val :*) :void {
        _bb.setValue(_key, val);
    }
    
    public function removeValue () :void {
        _bb.removeKey(_key);
    }
    
    protected var _bb :Blackboard;
    protected var _key :String;
    protected var _type :Class;
    protected var _defaultVal :*;
}


