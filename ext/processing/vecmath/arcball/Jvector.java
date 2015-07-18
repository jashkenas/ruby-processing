/* 
 * Copyright (c) 2015 Martin Prout
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
package processing.vecmath.arcball;

/**
 *
 * @author Martin Prout
 */
public final class Jvector {

    static final double EPSILON = 9.999999747378752e-05;

    /**
     *
     */
    public double x;

    /**
     *
     */
    public double y;

    /**
     *
     */
    public double z;

    /**
     *
     * @param x
     * @param y
     * @param z
     */
    public Jvector(double x, double y, double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    /**
     *
     */
    public Jvector() {
        this(0.0f, 0.0f, 0.0f);
    }

     /**
      *
      * @param other
      * @return
      */
     public Jvector sub(Jvector other) {
         return new Jvector(this.x - other.x, this.y - other.y, this.z - other.z);
     }
 
     /**
      *
      * @param scalar
      * @return
      */
     public Jvector mult(double scalar) {
         return new Jvector(this.x * scalar, this.y * scalar, this.z * scalar);
     }

    /**
     *
     * @return
     */
    public double mag() {
        return Math.sqrt(x * x + y * y + z * z);
    }

    /**
     * The usual normalize
     *
     * @return this
     */
    public Jvector normalize() {
        double mag = Math.sqrt(x * x + y * y + z * z);
        this.x /= mag;
        this.y /= mag;
        this.z /= mag;
        return this;
    }

     /**
      *
      * @param other
      * @return
      */
     public double dot(Jvector other) {
         return x * other.x + y * other.y + z * other.z;
     }
 
     /**
      *
      * @param other
      * @return
      */
     public Jvector cross(Jvector other) {
         double xc = y * other.z - z * other.y;
         double yc = z * other.x - x * other.z;
         double zc = x * other.y - y * other.x;
         return new Jvector(xc, yc, zc);
     }   
}
