package monkstone.vecmath.vec2;

import java.io.IOException;
import org.jruby.Ruby;
import org.jruby.runtime.load.Library;


/**
 *
 * @author Martin Prout
 */
public class Vec2Library implements Library{

    /**
     *
     * @param runtime
     * @param wrap
     * @throws IOException
     */
    @Override
    public void load(final Ruby runtime, boolean wrap) throws IOException {
        Vec2.createVec2(runtime);
    }  
}
