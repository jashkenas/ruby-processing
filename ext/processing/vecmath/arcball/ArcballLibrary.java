package processing.vecmath.arcball;

import java.io.IOException;
import org.jruby.Ruby;
import org.jruby.runtime.load.Library;

/**
 *
 * @author Martin Prout
 */
public class ArcballLibrary implements Library {

    /**
     *
     * @param runtime
     * @param wrap
     * @throws IOException
     */
    @Override
    public void load(final Ruby runtime, boolean wrap) throws IOException {
        Rarcball.createArcBall(runtime);
    }
}
