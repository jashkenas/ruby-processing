package monkstone.fastmath;

import org.jruby.Ruby;
import org.jruby.RubyClass;
import org.jruby.RubyModule;
import org.jruby.RubyObject;
import org.jruby.anno.JRubyClass;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;

/**
*
* @author Martin Prout
*/
@JRubyClass(name = "DegLut")
public class Deglut extends RubyObject {
  
  /**
  * Lookup table for degree cosine/sine, has a fixed precision 1.0
  * degrees Quite accurate but imprecise
  *
  * @author Martin Prout <martin_p@lineone.net>
  */
  static final double[] SIN_DEG_LUT = new double[91];
  /**
  *
  */
  public static final double TO_RADIANS = Math.PI / 180;
  /**
  *
  */
  private static boolean initialized = false;
  
  private final static int NINETY = 90;
  private final static int FULL = 360;
    private static final long serialVersionUID = -1466528933765940101L;
  
  /**
  * Initialise sin table with values (first quadrant only)
  */
  public static final void initTable() {
    if (initialized == false) {
      for (int i = 0; i <= NINETY; i++) {
        SIN_DEG_LUT[i] = Math.sin(TO_RADIANS * i);
      }
      initialized = true;
    }
  }  
  
  
  /**
  *
  * @param runtime
  */
  
  public static void createDeglut(final Ruby runtime){
    RubyModule deglutModule = runtime.defineModule("DegLut");
    deglutModule.defineAnnotatedMethods(Deglut.class);
    Deglut.initTable();
  }  
  
  
  /**
  *
  * @param runtime
  * @param klass
  */
  private Deglut(Ruby runtime, RubyClass klass) {
    super(runtime, klass);
  }
  
  /**
  *
  * @param context
  * @param klazz
  * @param other
  * @return sin float
  */
  @JRubyMethod(name = "sin", meta = true)
  
  public static IRubyObject sin(ThreadContext context, IRubyObject klazz, IRubyObject other) {
    int thet = (Integer) other.toJava(Integer.class);
    while (thet < 0) {
      thet += FULL; // Needed because negative modulus plays badly in java
    }
    int theta = thet % FULL;
    int y = theta % NINETY;
    double result = (theta < NINETY) ? SIN_DEG_LUT[y] : (theta < 180)
    ? SIN_DEG_LUT[NINETY - y] : (theta < 270)
    ? -SIN_DEG_LUT[y] : -SIN_DEG_LUT[NINETY - y];
    return context.getRuntime().newFloat(result);
  }
  
  /**
  *
  * @param context
  * @param klazz
  * @param other
  * @return cos float
  */
  @JRubyMethod(name = "cos", meta = true)
  public static IRubyObject cos(ThreadContext context, IRubyObject klazz, IRubyObject other) {
    int thet = (Integer) other.toJava(Integer.class);
    while (thet < 0) {
      thet += FULL; // Needed because negative modulus plays badly in java
    }
    int theta = thet % FULL;
    int y = theta % NINETY;
    double result = (theta < NINETY) ? SIN_DEG_LUT[NINETY - y] : (theta < 180)
    ? -SIN_DEG_LUT[y] : (theta < 270)
    ? -SIN_DEG_LUT[NINETY - y] : SIN_DEG_LUT[y];
    return context.getRuntime().newFloat(result);
  }  
}
