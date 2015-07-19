/* 
 * Copyright (c) 2014 Martin Prout
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

package monkstone.arcball;

/**
 * Based on a original sketch by Ariel Malka
 * Arcball quaternion idea by Ken Shoemake
 * http://dl.acm.org/citation.cfm?id=325242
 * A google of the quaternions term will find a 
 * freely down-loadable article by Ken Shoemake.
 * @author Martin Prout
 */
public final class Quaternion {

    private float w, x, y, z;

    /**
     * 
     */
    public Quaternion() {
        reset();
    }

    /**
     * 
     * @param w
     * @param x
     * @param y
     * @param z
     */
    public Quaternion(float w, float x, float y, float z) {
        this.w = w;
        this.x = x;
        this.y = y;
        this.z = z;
    }

    /**
     * 
     */
    public final void reset() {
        w = 1.0f;
        x = 0.0f;
        y = 0.0f;
        z = 0.0f;
    }

    /**
     * 
     * @param w scalar 
     * @param v custom Vector class
     */
    public void set(float w, Jvector v) {
        this.w = w;
        x = v.x;
        y = v.y;
        z = v.z;
    }

    /**
     * 
     * @param q
     */
    public void set(Quaternion q) {
        w = q.w;
        x = q.x;
        y = q.y;
        z = q.z;
    }

    /**
     * 
     * @param q1
     * @param q2
     * @return
     */
    public static Quaternion mult(Quaternion q1, Quaternion q2) {
        float w = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z;
        float x = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y;
        float y = q1.w * q2.y + q1.y * q2.w + q1.z * q2.x - q1.x * q2.z;
        float z = q1.w * q2.z + q1.z * q2.w + q1.x * q2.y - q1.y * q2.x;
        return new Quaternion(w, x, y, z);
    }
    
    /**
     * Transform this Quaternion into an angle (radians) and an axis vector, about 
     * which to rotate (avoids NaN by setting sa to 1.0F when sa < epsilon)
     * @return a new float[] where a0 = angle and a1 .. a3 are axis vector
     */

    public float[] getValue() {
        float sa = (float) Math.sqrt(1.0 - w * w);
        if (sa < processing.core.PConstants.EPSILON) {
            sa = 1.0f;
        }
        return new float[]{(float) Math.acos(w) * 2.0f, x / sa, y / sa, z / sa};
    }
}
