package monkstone.fastmath;

import java.io.IOException;
import org.jruby.Ruby;
import org.jruby.runtime.load.Library;


/**
 *
 * @author Martin Prout
 */
public class DeglutLibrary implements Library {

    /**
     *
     * @param runtime
     * @param wrap
     * @throws IOException
     */
    @Override
    public void load(final Ruby runtime, boolean wrap) throws IOException {
        Deglut.createDeglut(runtime);
    }
    
}

