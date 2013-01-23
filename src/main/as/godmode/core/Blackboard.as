//
// godmode

package godmode.core {

import flash.utils.Dictionary;

public class Blackboard
{
    public function containsKey (key :String) :Boolean {
        return (key in _dict);
    }
    
    public function removeKey (key :String) :void {
        delete _dict[key];
    }
    
    public function getObject (key :String) :* {
        return _dict[key];
    }
    
    public function getBool (key :String) :Boolean {
        return getValue(key, Boolean, false);
    }
    
    public function getInt (key :String) :int {
        return getValue(key, int, 0);
    }
    
    public function getNumber (key :String) :Number {
        return getValue(key, Number, 0);
    }
    
    public function setValue (key :String, val :*) :void {
        _dict[key] = val;
    }
    
    protected function getValue (key :String, type :Class, defaultVal :*) :* {
        var obj :* = getObject(key);
        return (obj is type ? obj : defaultVal);
    }
    
    protected var _dict :Dictionary = new Dictionary();
}
}
