package monkstone.vecmath.vec3;

import java.io.IOException;
import org.jruby.Ruby;
import org.jruby.runtime.load.Library;

/**
 *
 * @author Martin Prout
 */
public class Vec3Library implements Library {
  
    /**
     *
     * @param runtime
     */
    public static void load(final Ruby runtime) {
        Vec3.createVec3(runtime);
    }

    /**
     *
     * @param runtime
     * @param wrap
     * @throws IOException
     */
    @Override
    public void load(final Ruby runtime, boolean wrap) throws IOException {
        load(runtime);
    }
}
