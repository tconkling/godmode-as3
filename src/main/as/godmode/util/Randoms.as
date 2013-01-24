//
// aspire

package godmode.util {

import godmode.core.RandomStream;

/**
 * <p>Provides utility routines to simplify obtaining randomized values.</p>
 */
public class Randoms
{
    /**
     * Construct a Randoms.
     */
    public function Randoms (stream :RandomStream)
    {
        _stream = stream;
    }

    /**
     * Returns a pseudorandom, uniformly distributed <code>int</code> value between <code>0</code>
     * (inclusive) and <code>high</code> (exclusive).
     *
     * @param high the high value limiting the random number sought.
     *
     * @throws IllegalArgumentException if <code>high</code> is not positive.
     */
    public function getInt (high :int) :int
    {
        return _stream.nextInt(high);
    }

    /**
     * Returns a pseudorandom, uniformly distributed <code>int</code> value between
     * <code>low</code> (inclusive) and <code>high</code> (exclusive).
     *
     * @throws IllegalArgumentException if <code>high - low</code> is not positive.
     */
    public function getInRange (low :int, high :int) :int
    {
        return low + _stream.nextInt(high - low);
    }

    /**
     * Returns a pseudorandom, uniformly distributed <code>Number</code> value between
     * <code>0.0</code> (inclusive) and the <code>high</code> (exclusive).
     *
     * @param high the high value limiting the random number sought.
     */
    public function getNumber (high :Number) :Number
    {
        return _stream.nextNumber() * high;
    }

    /**
     * Returns a pseudorandom, uniformly distributed <code>Number</code> value between
     * <code>low</code> (inclusive) and <code>high</code> (exclusive).
     */
    public function getNumberInRange (low :Number, high :Number) :Number
    {
        return low + (_stream.nextNumber() * (high - low));
    }

    /**
     * Returns true approximately one in <code>n</code> times.
     *
     * @throws IllegalArgumentException if <code>n</code> is not positive.
     */
    public function getChance (n :int) :Boolean
    {
        return (0 == _stream.nextInt(n));
    }

    /**
     * Has a probability <code>p</code> of returning true.
     */
    public function getProbability (p :Number) :Boolean
    {
        return _stream.nextNumber() < p;
    }

    /**
     * Returns <code>true</code> or <code>false</code> with approximately even probability.
     */
    public function getBoolean () :Boolean
    {
        return getChance(2);
    }

    /**
     * Shuffle the specified array
     */
    public function shuffle (arr :Array) :void
    {
        // starting from the end of the list, repeatedly swap the element in question with a
        // random element previous to it up to and including itself
        for (var ii :int = arr.length; ii > 1; ii--) {
            var idx1 :int = ii - 1;
            var idx2 :int = getInt(ii);
            var tmp :* = arr[idx1];
            arr[idx1] = arr[idx2];
            arr[idx2] = tmp;
        }
    }

    /**
     * Pick a random element from the specified Array, or return <code>ifEmpty</code>
     * if it is empty.
     */
    public function pick (arr :Array, ifEmpty :* = undefined) :*
    {
        if (arr == null || arr.length == 0) {
            return ifEmpty;
        }

        return arr[_stream.nextInt(arr.length)];
    }

    /**
     * Pick a random element from the specified Array and remove it from the list, or return
     * <code>ifEmpty</code> if it is empty.
     */
    public function pluck (arr :Array, ifEmpty :* = undefined) :*
    {
        if (arr == null || arr.length == 0) {
            return ifEmpty;
        }

        return arr.splice(_stream.nextInt(arr.length), 1)[0];
    }

    protected var _stream :RandomStream;
}
}
