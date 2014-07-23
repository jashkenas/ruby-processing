package processing.vecmath.arcball;

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
 * @author tux
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
     * @param klazz
     * @param args optional (no args jx = 0, jy = 0)
     * @return Rarcballball object (ruby)
     */
    @JRubyMethod(name = "init", meta = true, rest = true, required = 1, optional = 3)

    static void init(ThreadContext context, IRubyObject self, IRubyObject args[]) {
        int count = Arity.checkArgumentCount(context.getRuntime(), args, 1, 4);
        if (count == 4) {
            PApplet parent = (PApplet) args[0].toJava(PApplet.class);
            float cx = (float) args[1].toJava(Float.class);
            float cy = (float) args[2].toJava(Float.class);
            float radius = (float) args[3].toJava(Float.class);
            new JArcBall(parent, cx, cy, radius).setActive(true);
        }
        if (count == 3) {
            PApplet parent = (PApplet) args[0].toJava(PApplet.class);
            float cx = (float) args[1].toJava(Float.class);
            float cy = (float) args[2].toJava(Float.class);
            new JArcBall(parent, cx, cy, parent.width * 0.8f).setActive(true);
        }
        if (count == 1) {
            PApplet parent = (PApplet) args[0].toJava(PApplet.class);
            new JArcBall(parent).setActive(true);
        }        
    }
}
