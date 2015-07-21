package monkstone.arcball;

import java.io.IOException;
import org.jruby.Ruby;
import org.jruby.RubyClass;
import org.jruby.RubyModule;
import org.jruby.RubyObject;
import org.jruby.anno.JRubyClass;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.Arity;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;
import processing.core.PApplet;

/**
 *
 * @author Martin Prout
 */
@JRubyClass(name = "ArcBall")
public class Rarcball extends RubyObject {

    /**
     *
     * @param runtime
     * @throws IOException
     */
    public static void createArcBall(final Ruby runtime) throws IOException {
        RubyModule processing = runtime.defineModule("Processing");
        RubyModule arcBallModule = processing.defineModuleUnder("ArcBall");
        arcBallModule.defineAnnotatedMethods(Rarcball.class);
    }

    /**
     *
     * @param runtime
     * @param metaClass
     */
    public Rarcball(Ruby runtime, RubyClass metaClass) {
        super(runtime, metaClass);
    }

    /**
     *
     * @param context
     * @param self
     * @param args optional (no args jx = 0, jy = 0)
     */
    @JRubyMethod(name = "init", meta = true, rest = true, required = 1, optional = 3)

    public static void init(ThreadContext context, IRubyObject self, IRubyObject args[]) {
        int count = Arity.checkArgumentCount(context.getRuntime(), args, 1, 4);
        if (count == 4) {
            PApplet parent = (PApplet) args[0].toJava(PApplet.class);
            double cx = (double) args[1].toJava(Double.class);
            double cy = (double) args[2].toJava(Double.class);
            double radius = (double) args[3].toJava(Double.class);
            new Arcball(parent, cx, cy, radius).setActive(true);
        }
        if (count == 3) {
            PApplet parent = (PApplet) args[0].toJava(PApplet.class);
            double cx = (double) args[1].toJava(Double.class);
            double cy = (double) args[2].toJava(Double.class);
            new Arcball(parent, cx, cy, parent.width * 0.8f).setActive(true);
        }
        if (count == 1) {
            PApplet parent = (PApplet) args[0].toJava(PApplet.class);
            new Arcball(parent).setActive(true);
        }        
    }
}
