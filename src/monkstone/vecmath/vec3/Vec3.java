package monkstone.vecmath.vec3;
/* 
 * Copyright (C) 2015-16 Martin Prout
 * 
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * http://creativecommons.org/licenses/LGPL/2.1/
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

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

    private static final long serialVersionUID = 1L;

    /**
     *
     * @param runtime
     */
    public static void createVec3(final Ruby runtime) {
        RubyClass vec3Cls = runtime.defineClass("Vec3D", runtime.getObject(), new ObjectAllocator() {
            @Override
            public IRubyObject allocate(Ruby runtime, RubyClass rubyClass) {
                return new Vec3(runtime, rubyClass);
            }
        });
        vec3Cls.defineAnnotatedMethods(Vec3.class);
    }

    static final double EPSILON = 9.999999747378752e-05; // matches processing.org EPSILON
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
     * @return jx float
     */
    @JRubyMethod(name = "x")

    public IRubyObject getX(ThreadContext context) {
        return context.getRuntime().newFloat(jx);
    }

    /**
     *
     * @param context
     * @return jy float
     */
    @JRubyMethod(name = "y")

    public IRubyObject getY(ThreadContext context) {
        return context.getRuntime().newFloat(jy);
    }

    /**
     *
     * @param context
     * @return jz float
     */
    @JRubyMethod(name = "z")
    public IRubyObject getZ(ThreadContext context) {
        return context.getRuntime().newFloat(jz);
    }

    /**
     *
     * @param context
     * @param other
     * @return jx float
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
     * @return jy float
     */
    @JRubyMethod(name = "y=")

    public IRubyObject setY(ThreadContext context, IRubyObject other) {
        jy = (Double) other.toJava(Double.class);
        return context.getRuntime().newFloat(jy);
    }

    /**
     *
     * @param context
     * @param other
     * @return jz float
     */
    @JRubyMethod(name = "z=")
    public IRubyObject setZ(ThreadContext context, IRubyObject other) {
        jz = (Double) other.toJava(Double.class);
        return context.getRuntime().newFloat(jz);
    }

    /**
     *
     * @param context
     * @param other
     * @return distance between float
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
     * @return distance squared between float
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
     * @return cross product as a new Vec3D
     */
    @JRubyMethod(name = "cross", required = 1)

    public IRubyObject cross(ThreadContext context, IRubyObject other) {
        Ruby runtime = context.getRuntime();
        Vec3 vec = null;
        if (other instanceof Vec3) {
            vec = (Vec3) other.toJava(Vec3.class);
        } else {
            throw runtime.newTypeError("argument should be Vec3D");
        }
        return Vec3.rbNew(context, other.getMetaClass(), new IRubyObject[]{
            runtime.newFloat(jy * vec.jz - jz * vec.jy),
            runtime.newFloat(jz * vec.jx - jx * vec.jz),
            runtime.newFloat(jx * vec.jy - jy * vec.jx)
        }
        );
    }

    /**
     *
     * @param context
     * @param other
     * @return do product as a float
     */
    @JRubyMethod(name = "dot", required = 1)

    public IRubyObject dot(ThreadContext context, IRubyObject other) {
        Ruby runtime = context.getRuntime();
        Vec3 b = null;
        if (other instanceof Vec3) {
            b = (Vec3) other.toJava(Vec3.class);
        } else {
            throw runtime.newTypeError("argument should be Vec3D");
        }
        return runtime.newFloat(jx * b.jx + jy * b.jy + jz * b.jz);
    }

    /**
     *
     * @param context
     * @param other
     * @return new Vec3 object (ruby)
     */
    @JRubyMethod(name = "+", required = 1)

    public IRubyObject op_add(ThreadContext context, IRubyObject other) {
        Ruby runtime = context.getRuntime();
        Vec3 b = (Vec3) other.toJava(Vec3.class);
        return Vec3.rbNew(context, other.getMetaClass(), new IRubyObject[]{
            runtime.newFloat(jx + b.jx),
            runtime.newFloat(jy + b.jy),
            runtime.newFloat(jz + b.jz)});
    }

    /**
     *
     * @param context
     * @param other
     * @return new Vec3 object (ruby)
     */
    @JRubyMethod(name = "-")

    public IRubyObject op_sub(ThreadContext context, IRubyObject other) {
        Ruby runtime = context.getRuntime();
        Vec3 b = null;
        if (other instanceof Vec3) {
            b = (Vec3) other.toJava(Vec3.class);
        } else {
            throw runtime.newTypeError("argument should be Vec3D");
        }
        return Vec3.rbNew(context, other.getMetaClass(), new IRubyObject[]{
            runtime.newFloat(jx - b.jx),
            runtime.newFloat(jy - b.jy),
            runtime.newFloat(jz - b.jz)});
    }

    /**
     *
     * @param context
     * @param other
     * @return new Vec3 object (ruby)
     */
    @JRubyMethod(name = "*", required = 1)

    public IRubyObject op_mul(ThreadContext context, IRubyObject other) {
        Ruby runtime = context.getRuntime();
        double scalar = (Double) other.toJava(Double.class);
        return Vec3.rbNew(context, this.getMetaClass(), new IRubyObject[]{
            runtime.newFloat(jx * scalar),
            runtime.newFloat(jy * scalar),
            runtime.newFloat(jz * scalar)});
    }

    /**
     *
     * @param context
     * @param other
     * @return new Vec3 object (ruby)
     */
    @JRubyMethod(name = "/", required = 1)

    public IRubyObject op_div(ThreadContext context, IRubyObject other) {
        Ruby runtime = context.getRuntime();
        double scalar = (Double) other.toJava(Double.class);
        if (Math.abs(scalar) < Vec3.EPSILON) {
            return this;
        }
        return Vec3.rbNew(context, this.getMetaClass(), new IRubyObject[]{
            runtime.newFloat(jx / scalar),
            runtime.newFloat(jy / scalar),
            runtime.newFloat(jz / scalar)});
    }

    /**
     *
     * @param context
     * @return magnitude squared float
     */
    @JRubyMethod(name = "mag_squared")

    public IRubyObject mag_squared(ThreadContext context) {
        return context.getRuntime().newFloat(jx * jx + jy * jy + jz * jz);
    }

    /**
     *
     * @param context
     * @return magnitude float
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
     * @return this with new magnitude
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
        if (current > EPSILON) {
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
        Ruby runtime = context.getRuntime();
        double mag = Math.sqrt(jx * jx + jy * jy + jz * jz);
        if (mag < EPSILON) {
            return Vec3.rbNew(context, this.getMetaClass(), new IRubyObject[]{
                runtime.newFloat(jx),
                runtime.newFloat(jy),
                runtime.newFloat(jz)});
        }
        return Vec3.rbNew(context, this.getMetaClass(), new IRubyObject[]{
            runtime.newFloat(jx / mag),
            runtime.newFloat(jy / mag),
            runtime.newFloat(jz / mag)});
    }

 /**
  * Example of a regular ruby class method 
  *
  * @param context
  * @param klazz
  * @return new Vec2 object (ruby)
  */
  @JRubyMethod(name = "random", meta = true)
    
    public static IRubyObject random_direction(ThreadContext context, IRubyObject klazz) {
    Ruby runtime = context.getRuntime();
    double angle = Math.random() * Math.PI * 2;
    double vz = Math.random() * 2 - 1;
    double vx = Math.sqrt(1 - vz * vz) * Math.cos(angle);
    double vy = Math.sqrt(1 - vz * vz) * Math.sin(angle);

    return Vec3.rbNew(context, klazz, new IRubyObject[]{
        runtime.newFloat(vx),
        runtime.newFloat(vy),
        runtime.newFloat(vz)});
  }


    /**
     *
     * @param context
     * @param other
     * @return angle between radians
     */
    @JRubyMethod(name = "angle_between")

    public IRubyObject angleBetween(ThreadContext context, IRubyObject other) {
        Ruby runtime = context.getRuntime();
        Vec3 vec = (Vec3) other.toJava(Vec3.class);
        // We get NaN if we pass in a zero vector which can cause problems
        // Zero seems like a reasonable angle between a (0,0,0) vector and something else
        if (jx == 0 && jy == 0 && jz == 0) {
            return runtime.newFloat(0.0);
        }
        if (vec.jx == 0 && vec.jy == 0 && vec.jz == 0) {
            return runtime.newFloat(0.0);
        }

        double dot = jx * vec.jx + jy * vec.jy + jz * vec.jz;
        double v1mag = Math.sqrt(jx * jx + jy * jy + jz * jz);
        double v2mag = Math.sqrt(vec.jx * vec.jx + vec.jy * vec.jy + vec.jz * vec.jz);
        // This should be a number between -1 and 1, since it's "normalized"
        double amt = dot / (v1mag * v2mag);
        if (amt <= -1) {
            return runtime.newFloat(Math.PI);
        } else if (amt >= 1) {
            return runtime.newFloat(0.0);
        }
        return runtime.newFloat(Math.acos(amt));
    }

    /**
     *
     * @param context
     * @return a deep copy
     */
    @JRubyMethod(name = {"copy", "dup"})

    public IRubyObject copy(ThreadContext context) {
        Ruby runtime = context.getRuntime();
        return Vec3.rbNew(context, this.getMetaClass(), new IRubyObject[]{
            runtime.newFloat(jx),
            runtime.newFloat(jy),
            runtime.newFloat(jz)});
    }

    /**
     *
     * @param context
     * @return as an array of float
     */
    @JRubyMethod(name = "to_a")

    public IRubyObject toArray(ThreadContext context) {
        Ruby runtime = context.getRuntime();
        return RubyArray.newArray(context.runtime, new IRubyObject[]{
            runtime.newFloat(jx),
            runtime.newFloat(jy),
            runtime.newFloat(jz)});
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
     *
     * @param context
     * @return custom to string (inspect)
     */
    @JRubyMethod(name = {"to_s", "inspect"})

    public IRubyObject to_s(ThreadContext context) {
        return context.getRuntime().newString(String.format("Vec3D(x = %4.4f, y = %4.4f, z = %4.4f)", jx, jy, jz));
    }

    /**
     *
     * @return hash int
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
     * @return equals boolean
     */
    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Vec3) {
            final Vec3 other = (Vec3) obj;
            if (!((Double) this.jx).equals(other.jx)) {
                return false;
            }
            if (!((Double) this.jy).equals(other.jy)) {
                return false;
            }
            return ((Double) this.jz).equals(other.jz);
        }
        return false;
    }

    /**
     *
     * @param context
     * @param other
     * @return eql? boolean
     */
    @JRubyMethod(name = "eql?", required = 1)

    public IRubyObject eql_p(ThreadContext context, IRubyObject other) {
        if (other instanceof Vec3) {
            Vec3 v = (Vec3) other.toJava(Vec3.class);
            if (!((Double) this.jx).equals(v.jx)) {
                return RubyBoolean.newBoolean(context.runtime, false);
            }
            if (!((Double) this.jy).equals(v.jy)) {
                return RubyBoolean.newBoolean(context.runtime, false);
            }
            return RubyBoolean.newBoolean(context.runtime, ((Double) this.jz).equals(v.jz));
        }
        return RubyBoolean.newBoolean(context.runtime, false);
    }

    /**
     *
     * @param context
     * @param other
     * @return eql? boolean
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
