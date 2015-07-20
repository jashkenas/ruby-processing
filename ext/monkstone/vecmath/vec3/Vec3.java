package monkstone.vecmath.vec3;

import java.io.IOException;
import org.jruby.Ruby;
import org.jruby.RubyArray;
import org.jruby.RubyBoolean;
import org.jruby.RubyClass;
import org.jruby.RubyObject;
import org.jruby.anno.JRubyClass;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.Arity;
import org.jruby.runtime.Block;
import org.jruby.runtime.ObjectAllocator;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;
import monkstone.vecmath.JRender;


/**
*
* @author Martin Prout
*/
@JRubyClass(name = "Vec3D")
public final class Vec3 extends RubyObject {
    
    /**
    *
    * @param runtime
    * @throws IOException
    */
    public static void createVec3(final Ruby runtime) throws IOException {
        RubyClass vec3Cls = runtime.defineClass("Vec3D", runtime.getObject(), new ObjectAllocator() {
                @Override
                public IRubyObject allocate(Ruby runtime, RubyClass rubyClass) {
                    return new Vec3(runtime, rubyClass);
                }
        });
        vec3Cls.defineAnnotatedMethods(Vec3.class);
    }
    
    static final double EPSILON = 1.0e-04; // matches processing.org EPSILON
    private double jx = 0;
    private double jy = 0;
    private double jz = 0;
    
    /**
    *
    * @param context
    * @param klazz
    * @param args optional (no args jx = 0, jy = 0, jz = 0) (2 args jz = 0)
    * @return new Vec3 object (ruby)
    */
    @JRubyMethod(name = "new", meta = true, rest = true)
    public final static IRubyObject rbNew(ThreadContext context, IRubyObject klazz, IRubyObject[] args) {
        Vec3 vec = (Vec3) ((RubyClass) klazz).allocate();
        vec.init(context, args);
        return vec;
    }
    
    /**
    *
    * @param runtime
    * @param klass
    */
    public Vec3(Ruby runtime, RubyClass klass) {
        super(runtime, klass);
        
    }
    
    void init(ThreadContext context, IRubyObject[] args) {
        int count = Arity.checkArgumentCount(context.getRuntime(), args, Arity.OPTIONAL.getValue(), 3);
        if (count >= 2) {
            jx = (Double) args[0].toJava(Double.class);
            jy = (Double) args[1].toJava(Double.class);
        }
        if (count == 3) {
            jz = (Double) args[2].toJava(Double.class);
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
    * @return
    */
    @JRubyMethod(name = "z")
    public IRubyObject getZ(ThreadContext context) {
        return context.getRuntime().newFloat(jz);
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
        return other;
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
        return other;
    }
    
    /**
    *
    * @param context
    * @param other
    * @return
    */
    @JRubyMethod(name = "z=")
    public IRubyObject setZ(ThreadContext context, IRubyObject other) {
        jz = (Double) other.toJava(Double.class);
        return other;
    }
    
    /**
    *
    * @param context
    * @param other
    * @return
    */
    @JRubyMethod(name = "dist", required = 1)
    
    public IRubyObject dist(ThreadContext context, IRubyObject other) {
        Vec3 b = null;
        if (other instanceof Vec3) {
            b = (Vec3) other.toJava(Vec3.class);
        } else {
            throw context.runtime.newTypeError("argument should be Vec3D");
        }
        double result = Math.sqrt((jx - b.jx) * (jx - b.jx) + (jy - b.jy) * (jy - b.jy) + (jz - b.jz) * (jz - b.jz));
        return context.getRuntime().newFloat(result);
    }
    
    /**
    *
    * @param context
    * @param other
    * @return
    */
    @JRubyMethod(name = "dist_squared", required = 1)
    
    public IRubyObject dist_squared(ThreadContext context, IRubyObject other) {
        Vec3 b = null;
        if (other instanceof Vec3) {
            b = (Vec3) other.toJava(Vec3.class);
        } else {
            throw context.runtime.newTypeError("argument should be Vec3D");
        }
        double result = (jx - b.jx) * (jx - b.jx) + (jy - b.jy) * (jy - b.jy) + (jz - b.jz) * (jz - b.jz);
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
        Vec3 vec = null;
        if (other instanceof Vec3) {
            vec = (Vec3) other.toJava(Vec3.class);
        } else {
            throw context.runtime.newTypeError("argument should be Vec3D");
        }
        return Vec3.rbNew(context, other.getMetaClass(), new IRubyObject[]{
            context.runtime.newFloat(jy * vec.jz - jz * vec.jy),
            context.runtime.newFloat(jz * vec.jx - jx * vec.jz),
            context.runtime.newFloat(jx * vec.jy - jy * vec.jx)
        }
        );
    }
    
    /**
    *
    * @param context
    * @param other
    * @return
    */
    @JRubyMethod(name = "dot", required = 1)
    
    public IRubyObject dot(ThreadContext context, IRubyObject other) {
        Vec3 b = null;
        if (other instanceof Vec3) {
            b = (Vec3) other.toJava(Vec3.class);
        } else {
            throw context.runtime.newTypeError("argument should be Vec3D");
        }
        return context.getRuntime().newFloat(jx * b.jx + jy * b.jy + jz * b.jz);
    }
    
    /**
    *
    * @param context
    * @param other
    * @return new Vec3 object (ruby)
    */
    @JRubyMethod(name = "+", required = 1)
    
    public IRubyObject op_add(ThreadContext context, IRubyObject other) {
        Vec3 b = (Vec3) other.toJava(Vec3.class);
        return Vec3.rbNew(context, other.getMetaClass(), new IRubyObject[]{
                context.runtime.newFloat(jx + b.jx),
                context.runtime.newFloat(jy + b.jy),
        context.runtime.newFloat(jz + b.jz)});
    }
    
    /**
    *
    * @param context
    * @param other
    * @return new Vec3 object (ruby)
    */
    @JRubyMethod(name = "-")
    
    public IRubyObject op_sub(ThreadContext context, IRubyObject other) {
        Vec3 b = null;
        if (other instanceof Vec3) {
            b = (Vec3) other.toJava(Vec3.class);
        } else {
            throw context.runtime.newTypeError("argument should be Vec3D");
        }
        return Vec3.rbNew(context, other.getMetaClass(), new IRubyObject[]{
                context.runtime.newFloat(jx - b.jx),
                context.runtime.newFloat(jy - b.jy),
        context.runtime.newFloat(jz - b.jz)});
    }
    
    /**
    *
    * @param context
    * @param other
    * @return new Vec3 object (ruby)
    */
    @JRubyMethod(name = "*", required = 1)
    
    public IRubyObject op_mul(ThreadContext context, IRubyObject other) {
        double scalar = (Double) other.toJava(Double.class);
        return Vec3.rbNew(context, this.getMetaClass(), new IRubyObject[]{
                context.runtime.newFloat(jx * scalar),
                context.runtime.newFloat(jy * scalar),
        context.runtime.newFloat(jz * scalar)});
    }
    
    /**
    *
    * @param context
    * @param other
    * @return new Vec3 object (ruby)
    */
    @JRubyMethod(name = "/", required = 1)
    
    public IRubyObject op_div(ThreadContext context, IRubyObject other) {
        double scalar = (Double) other.toJava(Double.class);
        if (Math.abs(scalar) < Vec3.EPSILON) {
            return this;
        }
        return Vec3.rbNew(context, this.getMetaClass(), new IRubyObject[]{
                context.runtime.newFloat(jx / scalar),
                context.runtime.newFloat(jy / scalar),
        context.runtime.newFloat(jz / scalar)});
    }
    
    /**
    *
    * @param context
    * @return
    */
    @JRubyMethod(name = "mag_squared")
    
    public IRubyObject mag_squared(ThreadContext context) {
        return context.getRuntime().newFloat(jx * jx + jy * jy + jz * jz);
    }
    
    /**
    *
    * @param context
    * @return
    */
    @JRubyMethod(name = "mag")
    
    public IRubyObject mag(ThreadContext context) {
        return context.getRuntime().newFloat(Math.sqrt(jx * jx + jy * jy + jz * jz));
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
        if (block.isGiven()) {
            if (!(boolean) block.yield(context, scalar).toJava(Boolean.class)) {
                return this;
            }
        }
        double new_mag = (Double) scalar.toJava(Double.class);
        double current = Math.sqrt(jx * jx + jy * jy + jz * jz);
        if (current > EPSILON){
            jx *= new_mag / current;
            jy *= new_mag / current;
            jz *= new_mag / current;
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
        if (Math.abs(jx) < EPSILON && Math.abs(jy) < EPSILON && Math.abs(jz) < EPSILON) {
            return this;
        }
        double mag = Math.sqrt(jx * jx + jy * jy + jz * jz); 
        jx /= mag;
        jy /= mag;
        jz /= mag;
        return this;
    }
    
    /**
    *
    * @param context
    * @return new Vec3 object (ruby)
    */
    @JRubyMethod(name = "normalize")
    
    public IRubyObject normalize(ThreadContext context) {
        double mag = Math.sqrt(jx * jx + jy * jy + jz * jz);
        if (mag < EPSILON){return Vec3.rbNew(context, this.getMetaClass(), new IRubyObject[]{
                context.runtime.newFloat(jx),
                context.runtime.newFloat(jy),
            context.runtime.newFloat(jz)});          
        }
        return Vec3.rbNew(context, this.getMetaClass(), new IRubyObject[]{
                context.runtime.newFloat(jx / mag),
                context.runtime.newFloat(jy / mag),
        context.runtime.newFloat(jz / mag)});
    }
    
    /**
    *
    * @param context
    * @param other
    * @return
    */
    @JRubyMethod(name = "angle_between")
    
    public IRubyObject angleBetween(ThreadContext context, IRubyObject other) {
        Vec3 vec = (Vec3) other.toJava(Vec3.class);
        // We get NaN if we pass in a zero vector which can cause problems
        // Zero seems like a reasonable angle between a (0,0,0) vector and something else
        if (jx == 0 && jy == 0 && jz == 0) {
            return context.runtime.newFloat(0.0);
        }
        if (vec.jx == 0 && vec.jy == 0 && vec.jz == 0) {
            return context.runtime.newFloat(0.0);
        }
        
        double dot = jx * vec.jx + jy * vec.jy + jz * vec.jz;
        double v1mag = Math.sqrt(jx * jx + jy * jy + jz * jz);
        double v2mag = Math.sqrt(vec.jx * vec.jx + vec.jy * vec.jy + vec.jz * vec.jz);
        // This should be a number between -1 and 1, since it's "normalized"
        double amt = dot / (v1mag * v2mag);
        if (amt <= -1) {
            return context.runtime.newFloat(Math.PI);
        } else if (amt >= 1) {
            return context.runtime.newFloat(0.0);
        }
        return context.runtime.newFloat(Math.acos(amt));
    }
    
    /**
    *
    * @param context
    * @return
    */
    @JRubyMethod(name = {"copy", "dup"})
    
    public IRubyObject copy(ThreadContext context) {
        return Vec3.rbNew(context, this.getMetaClass(), new IRubyObject[]{
                context.runtime.newFloat(jx),
                context.runtime.newFloat(jy),
        context.runtime.newFloat(jz)});
    }
    
    /**
    *
    * @param context
    * @return
    */
    @JRubyMethod(name = "to_a")
    
    public IRubyObject toArray(ThreadContext context) {
        return RubyArray.newArray(context.runtime, new IRubyObject[]{
                context.runtime.newFloat(jx),
                context.runtime.newFloat(jy),
        context.runtime.newFloat(jz)});
    }
    
    
    /**
    *
    * @param context
    * @param object
    */
    @JRubyMethod(name = "to_vertex")
    
    public void toVertex(ThreadContext context, IRubyObject object) {
        JRender renderer = (JRender) object.toJava(JRender.class);
        renderer.vertex(jx, jy, jz);
    }
    
       /**
    *
    * @param context
    * @param object
    */
    @JRubyMethod(name = "to_curve_vertex")

    public void toCurveVertex(ThreadContext context, IRubyObject object) {
        JRender renderer = (JRender) object.toJava(JRender.class);
        renderer.curveVertex(jx, jy, jz);
    }
    
    /**
    * 
    * @param context
    * @param args
    */
    @JRubyMethod(name = "to_vertex_uv", rest = true)
    
    public void toVertexUV(ThreadContext context, IRubyObject[] args) {
        Arity.checkArgumentCount(context.getRuntime(), args, 3, 3);
        double u = (Double) args[1].toJava(Double.class);
        double v = (Double) args[2].toJava(Double.class);
        JRender renderer = (JRender) args[0].toJava(JRender.class);        
        renderer.vertex(jx, jy, jz, u, v);
    }
    
    /**
    *
    * @param context
    * @param object
    */
    @JRubyMethod(name = "to_normal")
    
    public void toNormal(ThreadContext context, IRubyObject object) {
        JRender renderer = (JRender) object.toJava(JRender.class);
        renderer.normal(jx, jy, jz);
    }
    
    /**
    * For jruby-9000 we alias to inspect
    * @param context
    * @return
    */
    @JRubyMethod(name = {"to_s", "inspect"})
    
    public IRubyObject to_s(ThreadContext context) {
        return context.getRuntime().newString(String.format("Vec3D(x = %4.4f, y = %4.4f, z = %4.4f)", jx, jy, jz));
    }
    
    /**
    *
    * @return
    */
    @Override
    public int hashCode() {
        int hash = 7;
        hash = 97 * hash + (int) (Double.doubleToLongBits(this.jx) ^ (Double.doubleToLongBits(this.jx) >>> 32));
        hash = 97 * hash + (int) (Double.doubleToLongBits(this.jy) ^ (Double.doubleToLongBits(this.jy) >>> 32));
        hash = 97 * hash + (int) (Double.doubleToLongBits(this.jz) ^ (Double.doubleToLongBits(this.jz) >>> 32));
        return hash;
    }
    
    /**
    *
    * @param obj
    * @return
    */
    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Vec3) {
        final Vec3 other = (Vec3) obj;
        if (!((Double)this.jx).equals(other.jx)) {
            return false;
        }
        if (!((Double)this.jy).equals(other.jy)) {
            return false;
        }
        return ((Double)this.jz).equals(other.jz);
        }
        return false;
    }
        
   /**                                                                              
    *                                                                      
    * @param context
    * @param other                                                                     
    * @return                                                                        
    */                                                                               
    @JRubyMethod(name = "eql?", required = 1) 
    
    public IRubyObject eql_p(ThreadContext context, IRubyObject other) {
        if (other instanceof Vec3){                                                    
            Vec3 v = (Vec3) other.toJava(Vec3.class);                                              
            if (!((Double)this.jx).equals(v.jx)) {                                   
                return RubyBoolean.newBoolean(context.runtime, false);                                                          
            }  
            if (!((Double)this.jy).equals(v.jy)) {                                   
                return RubyBoolean.newBoolean(context.runtime, false);                                                          
            } 
            return RubyBoolean.newBoolean(context.runtime, ((Double)this.jz).equals(v.jz));                                   
        }                                                                            
        return RubyBoolean.newBoolean(context.runtime, false);                                                                     
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
        if (other instanceof Vec3) {
          Vec3 v = (Vec3) other.toJava(Vec3.class);
            double diff = jx - v.jx;
            if ((diff < 0 ? -diff : diff) > Vec3.EPSILON) {
                return RubyBoolean.newBoolean(context.runtime, false);
            }
            diff = jy - v.jy;
            if ((diff < 0 ? -diff : diff) > Vec3.EPSILON) {
                return RubyBoolean.newBoolean(context.runtime, false);
            }
            diff = jz - v.jz;
            boolean result = ((diff < 0 ? -diff : diff) < Vec3.EPSILON);
            return RubyBoolean.newBoolean(context.runtime, result);
        }
        return RubyBoolean.newBoolean(context.runtime, false);
    }
}
