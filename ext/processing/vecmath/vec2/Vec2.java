package processing.vecmath.vec2;

import org.jruby.Ruby;
import org.jruby.RubyArray;
import org.jruby.RubyBoolean;
import org.jruby.RubyClass;
import org.jruby.RubyFloat;
import org.jruby.RubyObject;
import org.jruby.anno.JRubyClass;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.Arity;
import org.jruby.runtime.Block;
import org.jruby.runtime.ObjectAllocator;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;
import processing.vecmath.JRender;

/**
*
* @author Martin Prout
*/
@JRubyClass(name = "Vec2D")
public class Vec2 extends RubyObject {

    static final double EPSILON = 1.0e-04; // matches processing.org EPSILON
    private double jx = 0;
    private double jy = 0;

    /**
    *
    * @param runtime
    */
    public static void createVec2(final Ruby runtime) {
        RubyClass vec2Cls = runtime.defineClass("Vec2D", runtime.getObject(), new ObjectAllocator() {
                @Override
                public IRubyObject allocate(Ruby runtime, RubyClass rubyClass) {
                    return new Vec2(runtime, rubyClass);
                }
        });
        vec2Cls.defineAnnotatedMethods(Vec2.class);

    }

    /**
    *
    * @param context
    * @param klazz
    * @param args optional (no args jx = 0, jy = 0)
    * @return new Vec2 object (ruby)
    */
    @JRubyMethod(name = "new", meta = true, rest = true)
    public static final IRubyObject rbNew(ThreadContext context, IRubyObject klazz, IRubyObject[] args) {
        Vec2 vec2 = (Vec2) ((RubyClass) klazz).allocate();
        vec2.init(context, args);
        return vec2;
    }

    /**
    *
    * @param runtime
    * @param klass
    */
    public Vec2(Ruby runtime, RubyClass klass) {
        super(runtime, klass);
    }

    void init(ThreadContext context, IRubyObject[] args) {
        if (Arity.checkArgumentCount(context.getRuntime(), args, Arity.OPTIONAL.getValue(), 2) == 2) {
            jx = (Double) args[0].toJava(Double.class);
            jy = (Double) args[1].toJava(Double.class);
        }
    }

    /**
    *
    * @param context
    * @return
    */
    @JRubyMethod(name = "x")

    public IRubyObject getX(ThreadContext context) {
        return context.getRuntime().newFloat(jx);
    }

    /**
    *
    * @param context
    * @return
    */
    @JRubyMethod(name = "y")

    public IRubyObject getY(ThreadContext context) {
        return context.getRuntime().newFloat(jy);
    }

    /**
    *
    * @param context
    * @param other
    * @return
    */
    @JRubyMethod(name = "x=")

    public IRubyObject setX(ThreadContext context, IRubyObject other) {
        jx = (Double) other.toJava(Double.class);
        return context.getRuntime().newFloat(jx);
    }

    /**
    *
    * @param context
    * @param other
    * @return
    */
    @JRubyMethod(name = "y=")

    public IRubyObject setY(ThreadContext context, IRubyObject other) {
        jy = (Double) other.toJava(Double.class);
        return context.getRuntime().newFloat(jy);
    }

    /**
    * Example of a regular ruby class method
    *
    * @deprecated use instance method
    * @param context
    * @param klazz
    * @param args
    * @return new Vec2 object (ruby)
    *
    */
    // @Deprecated
    // @JRubyMethod(name = "dist", meta = true, rest = true)
    // public static RubyFloat dist(ThreadContext context, IRubyObject klazz, IRubyObject[] args) {
    // Arity.checkArgumentCount(context.runtime, args, 2, 2);
    // Vec2 vec0 = (Vec2) args[0].toJava(Vec2.class);
    // Vec2 vec1 = (Vec2) args[1].toJava(Vec2.class);
    // return context.getRuntime().newFloat(Math.hypot((vec0.jx - vec1.jx), (vec0.jy - vec1.jy)));
    // }

    /**
    * Example of a regular ruby class method
    *
    * @deprecated use instance method
    * @param context
    * @param klazz
    * @param args
    * @return new Vec2 object (ruby)
    */
    // @Deprecated
    // @JRubyMethod(name = "dist_squared", meta = true, rest = true)
    // public static RubyFloat dist_squared(ThreadContext context, IRubyObject klazz, IRubyObject[] args) {
    // Arity.checkArgumentCount(context.runtime, args, 2, 2);
    // Vec2 vec0 = (Vec2) args[0].toJava(Vec2.class);
    // Vec2 vec1 = (Vec2) args[1].toJava(Vec2.class);
    // return context.getRuntime().newFloat((vec0.jx - vec1.jx) * (vec0.jx - vec1.jx) + (vec0.jy - vec1.jy) * (vec0.jy - vec1.jy));
    // }

    /**
    *
    * @param context
    * @param other
    * @return
    */
    @JRubyMethod(name = "dist", required = 1)

    public IRubyObject dist(ThreadContext context, IRubyObject other) {
        Vec2 b = null;
        if (other instanceof Vec2) {
            b = (Vec2) other.toJava(Vec2.class);
        } else {
            throw context.runtime.newTypeError("argument should be Vec2D");
        }
        double result = Math.hypot((jx - b.jx), (jy - b.jy));
        return context.getRuntime().newFloat(result);
    }

    /**
    *
    * @param context
    * @param other
    * @return
    */
    @JRubyMethod(name = "cross", required = 1)

    public IRubyObject cross(ThreadContext context, IRubyObject other) {
        Vec2 b = null;
        if (other instanceof Vec2) {
            b = (Vec2) other.toJava(Vec2.class);
        } else {
            throw context.runtime.newTypeError("argument should be Vec2D");
        }
        return context.getRuntime().newFloat(jx * b.jy - jy * b.jx);
    }

    /**
    *
    * @param context
    * @param other
    * @return
    */
    @JRubyMethod(name = "dot", required = 1)

    public IRubyObject dot(ThreadContext context, IRubyObject other) {
        Vec2 b = null;
        if (other instanceof Vec2) {
            b = (Vec2) other.toJava(Vec2.class);
        } else {
            throw context.runtime.newTypeError("argument should be Vec2D");
        }
        return context.getRuntime().newFloat(jx * b.jx + jy * b.jy);
    }

    /**
    *
    * @param context
    * @param other
    * @return new Vec2 object (ruby)
    */
    @JRubyMethod(name = "+", required = 1)

    public IRubyObject op_plus(ThreadContext context, IRubyObject other) {
        Vec2 b = null;
        if (other instanceof Vec2) {
            b = (Vec2) other.toJava(Vec2.class);
        } else {
            throw context.runtime.newTypeError("argument should be Vec2D");
        }
        return Vec2.rbNew(context, other.getMetaClass(), new IRubyObject[]{
                context.getRuntime().newFloat(jx + b.jx),
        context.getRuntime().newFloat(jy + b.jy)});
    }

    /**
    *
    * @param context
    * @param other
    * @return new Vec2 object (ruby)
    */
    @JRubyMethod(name = "-", required = 1)

    public IRubyObject op_minus(ThreadContext context, IRubyObject other) {
        Vec2 b = null;
        if (other instanceof Vec2) {
            b = (Vec2) other.toJava(Vec2.class);
        } else {
            throw context.runtime.newTypeError("argument should be Vec2D");
        }
        return Vec2.rbNew(context, other.getMetaClass(), new IRubyObject[]{
                context.getRuntime().newFloat(jx - b.jx),
        context.getRuntime().newFloat(jy - b.jy)});
    }

    /**
    *
    * @param context
    * @param other
    * @return new Vec2 object (ruby)
    */
    @JRubyMethod(name = "*")

    public IRubyObject op_mul(ThreadContext context, IRubyObject other) {
        double scalar = (Double) other.toJava(Double.class);
        return Vec2.rbNew(context, this.getMetaClass(),
            new IRubyObject[]{context.getRuntime().newFloat(jx * scalar),
            context.getRuntime().newFloat(jy * scalar)});
    }

    /**
    *
    * @param context
    * @param other
    * @return new Vec2 object (ruby)
    */
    @JRubyMethod(name = "/", required = 1)

    public IRubyObject op_div(ThreadContext context, IRubyObject other) {
        double scalar = (Double) other.toJava(Double.class);
        if (Math.abs(scalar) < Vec2.EPSILON) {
            return this;
        }
        return Vec2.rbNew(context, this.getMetaClass(), new IRubyObject[]{
                context.getRuntime().newFloat(jx / scalar),
        context.getRuntime().newFloat(jy / scalar)});
    }

    /**
    *
    * @param context
    * @return
    */
    @JRubyMethod(name = "heading")
    public IRubyObject heading(ThreadContext context) {
        return context.getRuntime().newFloat(Math.atan2(-jy, jx) * -1.0);
    }

    /**
    *
    * @param context
    * @return
    */
    @JRubyMethod(name = "mag")

    public IRubyObject mag(ThreadContext context) {
        double result = 0;
        if (Math.abs(jx) > EPSILON && Math.abs(jy) > EPSILON) {
            result = Math.hypot(jx, jy);
        }
        else{
            if (Math.abs(jy) > EPSILON) {
                result = Math.abs(jy);
            }
            if (Math.abs(jx) > EPSILON) {
                result = Math.abs(jx);
            }
        }
        return context.getRuntime().newFloat(result);
    }

    /**
    * Call yield if block given, do nothing if yield == false else set_mag to
    * given scalar
    *
    * @param context
    * @param scalar double value to set
    * @param block should return a boolean (optional)
    * @return
    */
    @JRubyMethod(name = "set_mag")

    public IRubyObject set_mag(ThreadContext context, IRubyObject scalar, Block block) {
        double new_mag = (Double) scalar.toJava(Double.class);
        if (block.isGiven()) {
            if (!(boolean) block.yield(context, scalar).toJava(Boolean.class)) {
                return this;
            }
        }
        double current = 0;
        if (Math.abs(jx) > EPSILON && Math.abs(jy) > EPSILON) {
            current = Math.hypot(jx, jy);
        }
        else{
            if (Math.abs(jy) > EPSILON) {
                current = Math.abs(jy);
            }
            if (Math.abs(jx) > EPSILON) {
                current = Math.abs(jx);
            }
        }
        if (current > 0) {
            jx *= new_mag / current;
            jy *= new_mag / current;
        }
        return this;
    }

    /**
    *
    * @param context
    * @return this as a ruby object
    */
    @JRubyMethod(name = "normalize!")

    public IRubyObject normalize_bang(ThreadContext context) {
        double mag = 0;
        if (Math.abs(jx) > EPSILON && Math.abs(jy) > EPSILON) {
            mag = Math.hypot(jx, jy);
        }
        else{
            if (Math.abs(jx) > EPSILON)  {
                mag = Math.abs(jx);
            }
            if (Math.abs(jy) > EPSILON)  {
                mag = Math.abs(jy);
            }
        }
        if (mag > 0) {
            jx /= mag;
            jy /= mag;
        }
        return this;
    }

    /**
    *
    * @param context
    * @return new Vec2 object (ruby)
    */
    @JRubyMethod(name = "normalize")

    public IRubyObject normalize(ThreadContext context) {
        double mag = 0;
        if (Math.abs(jx) > EPSILON && Math.abs(jy) > EPSILON) {
            mag = Math.hypot(jx, jy);
        }
        else{
            if (Math.abs(jx) > EPSILON)  {
                mag = jx;
            }
            if (Math.abs(jy) > EPSILON)  {
                mag = jy;
            }
        }
        if (mag < EPSILON) {
            mag = 1.0;
        }
        return Vec2.rbNew(context, this.getMetaClass(), new IRubyObject[]{
                context.getRuntime().newFloat(jx / mag),
        context.getRuntime().newFloat(jy / mag)});
    }

    /**
    * Example of a regular ruby class method Use Math rather than RadLut
    * here!!!
    *
    * @param context
    * @param klazz
    * @param other input angle in radians
    * @return new Vec2 object (ruby)
    */
    @JRubyMethod(name = "from_angle", meta = true)
    public static IRubyObject from_angle(ThreadContext context, IRubyObject klazz, IRubyObject other) {
        double scalar = (Double) other.toJava(Double.class);
        return Vec2.rbNew(context, klazz, new IRubyObject[]{
                context.getRuntime().newFloat(Math.cos(scalar)),
        context.getRuntime().newFloat(Math.sin(scalar))});
    }

    /**
    *
    * @param context
    * @param other
    * @return this Vec2 object rotated
    */
    @JRubyMethod(name = "rotate!")
    public IRubyObject rotate_bang(ThreadContext context, IRubyObject other) {
        double theta = (Double) other.toJava(Double.class);
        double x = (jx * Math.cos(theta) - jy * Math.sin(theta));
        double y = (jx * Math.sin(theta) + jy * Math.cos(theta));
        jx = x;
        jy = y;
        return this;
    }

    /**
    *
    * @param context
    * @param other
    * @return a new Vec2 object rotated
    */
    @JRubyMethod(name = "rotate")
    public IRubyObject rotate(ThreadContext context, IRubyObject other) {
        double theta = (Double) other.toJava(Double.class);
        IRubyObject[] ary = new IRubyObject[]{
            context.getRuntime().newFloat(jx * Math.cos(theta) - jy * Math.sin(theta)),
        context.getRuntime().newFloat(jx * Math.sin(theta) + jy * Math.cos(theta))};
        return Vec2.rbNew(context, this.getMetaClass(), ary);
    }

    /**
    *
    * @param context
    * @param args
    * @return as a new Vec2 object (ruby)
    */
    @JRubyMethod(name = "lerp", rest = true)
    public IRubyObject lerp(ThreadContext context, IRubyObject[] args) {
        Ruby runtime = context.getRuntime();
        Arity.checkArgumentCount(runtime, args, 2, 2);
        Vec2 vec = (Vec2) args[0].toJava(Vec2.class);
        double scalar = (Double) args[1].toJava(Double.class);
        assert (scalar >= 0 && scalar < 1.0) :
        "Lerp value " + scalar + " out of range 0 .. 1.0";
        return Vec2.rbNew(context, this.getMetaClass(), new IRubyObject[]{
                runtime.newFloat(jx + (vec.jx - jx) * scalar),
        runtime.newFloat(jy + (vec.jy - jy) * scalar)});
    }

    /**
    *
    * @param context
    * @param args
    * @return this
    */
    @JRubyMethod(name = "lerp!", rest = true)
    public IRubyObject lerp_bang(ThreadContext context, IRubyObject[] args) {
        Arity.checkArgumentCount(context.getRuntime(), args, 2, 2);
        Vec2 vec = (Vec2) args[0].toJava(Vec2.class);
        double scalar = (Double) args[1].toJava(Double.class);
        assert (scalar >= 0 && scalar < 1.0) :
        "Lerp value " + scalar + " out of range 0 .. 1.0";
        jx += (vec.jx - jx) * scalar;
        jy += (vec.jy - jy) * scalar;
        return this;
    }

    /**
    *
    * @param context
    * @param other
    * @return
    */
    @JRubyMethod(name = "angle_between")

    public IRubyObject angleBetween(ThreadContext context, IRubyObject other) {
        Vec2 vec = null;
        if (other instanceof Vec2) {
            vec = (Vec2) other.toJava(Vec2.class);
        } else {
            throw context.runtime.newTypeError("argument should be Vec2D");
        }
        return context.getRuntime().newFloat(Math.atan2(jx - vec.jx, jy - vec.jy));
    }

    /**
    *
    * @param context
    * @return
    */
    @JRubyMethod(name = "copy")

    public IRubyObject copy(ThreadContext context) {
        Ruby runtime = context.runtime;
        return Vec2.rbNew(context, this.getMetaClass(), new IRubyObject[]{runtime.newFloat(jx), runtime.newFloat(jy)});
    }

    /**
    *
    * @param context
    * @return
    */
    @JRubyMethod(name = "to_a")

    public IRubyObject toArray(ThreadContext context) {
        Ruby runtime = context.runtime;
        return RubyArray.newArray(context.getRuntime(), new IRubyObject[]{runtime.newFloat(jx), runtime.newFloat(jy)});
    }

    /**
    *
    * @param context
    * @param object
    */
    @JRubyMethod(name = "to_vertex")

    public void toVertex(ThreadContext context, IRubyObject object) {
        JRender renderer = (JRender) object.toJava(JRender.class);
        renderer.vertex(jx, jy);
    }
    
   /**
    *
    * @param context
    * @param object
    */
    @JRubyMethod(name = "to_curve_vertex")

    public void toCurveVertex(ThreadContext context, IRubyObject object) {
        JRender renderer = (JRender) object.toJava(JRender.class);
        renderer.curveVertex(jx, jy);
    }


    /**
    * For jruby-9000 we alias to inspect
    * @param context
    * @return
    */
    @JRubyMethod(name = "to_s", alias = "inspect")

    public IRubyObject to_s(ThreadContext context) {
        return context.getRuntime().newString(String.format("Vec2D(x = %4.4f, y = %4.4f)", jx, jy));
    }

    /**
    *
    * @return
    */
    @Override
    public int hashCode() {
        int hash = 5;
        hash = 53 * hash + (int) (Double.doubleToLongBits(this.jx) ^ (Double.doubleToLongBits(this.jx) >>> 32));
        hash = 53 * hash + (int) (Double.doubleToLongBits(this.jy) ^ (Double.doubleToLongBits(this.jy) >>> 32));
        return hash;
    }

    /**
    *
    * @param obj
    * @return
    */
    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Vec2 other = (Vec2) obj;
        if (Double.doubleToLongBits(this.jx) != Double.doubleToLongBits(other.jx)) {
            return false;
        }
        return (Double.doubleToLongBits(this.jy) == Double.doubleToLongBits(other.jy));
    }

    /**
    *
    * @param context
    * @param other
    * @return
    */
    @JRubyMethod(name = "==", required = 1)

    @Override
    public IRubyObject op_equal(ThreadContext context, IRubyObject other) {
        Vec2 v = (other instanceof Vec2) ? (Vec2) other.toJava(Vec2.class) : null;
        RubyBoolean result = (v == null) ? RubyBoolean.newBoolean(context.getRuntime(), false)
        : (Math.abs(jx - v.jx) > Vec2.EPSILON)
        ? RubyBoolean.newBoolean(context.getRuntime(), false)
        : (Math.abs(jy - v.jy) > Vec2.EPSILON)
        ? RubyBoolean.newBoolean(context.getRuntime(), false)
        : RubyBoolean.newBoolean(context.getRuntime(), true);
        return result; // return false as default unless not null && values equal
    }

    /**
    *
    * @param context
    * @param other
    * @return
    */
    //    @JRubyMethod(name = "almost_eql?", required = 1)
    //
    //    public IRubyObject almost_eql_p(ThreadContext context, IRubyObject other) {
    //        Vec2 v = (other instanceof Vec2) ? (Vec2) other.toJava(Vec2.class) : null;
    //        RubyBoolean result = (v == null) ? RubyBoolean.newBoolean(context.getRuntime(), false)
    //                : (Math.abs(jx - v.jx) > Vec2.EPSILON)
    //                ? RubyBoolean.newBoolean(context.getRuntime(), false)
    //                : (Math.abs(jy - v.jy) > Vec2.EPSILON)
    //                ? RubyBoolean.newBoolean(context.getRuntime(), false)
    //                : RubyBoolean.newBoolean(context.getRuntime(), true);
    //        return result; // return false as default unless not null && values equal
    //    }

}
