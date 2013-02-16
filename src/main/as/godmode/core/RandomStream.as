//
// godmode

package godmode.core {

public interface RandomStream
{
    /** Return an int between int.MIN_INT (inclusive) and int.MAX_INT (inclusive) */
    function next () :int;

    /**
     * Return an int between 0 (inclusive) and n (exclusive). n must be > 0.
     * (It's acceptable to just return next() % n, but some implementations may wish to special-case
     * this operation for better number distribution.)
     */
    function nextInt (n :int) :int;

    /** Return a Number between 0 (inclusive) and 1 (exclusive) */
    function nextNumber () :Number;
}
}
