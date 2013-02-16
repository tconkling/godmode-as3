//
// godmode

package godmode.core {

public class Semaphore
{
    public function Semaphore (name :String, maxUsers :int) {
        _name = name;
        _maxUsers = maxUsers;
    }

    public function get name () :String {
        return _name;
    }

    /** Returns true if at least one client holds the semaphore */
    public function get isAcquired () :Boolean {
        return (_refCount > 0);
    }

    public function acquire () :Boolean {
        if (_refCount < _maxUsers) {
            ++_refCount;
            return true;
        } else {
            return false;
        }
    }

    public function release () :void {
        if (_refCount <= 0) {
            throw new Error("refCount is 0");
        }
        --_refCount;
    }

    public function toString () :String {
        return "[name=" + _name + " refCount=" + _refCount + "]";
    }

    protected var _name :String;
    protected var _maxUsers :int;
    protected var _refCount :int;
}
}
