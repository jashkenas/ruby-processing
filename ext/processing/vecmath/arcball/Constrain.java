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

package processing.vecmath.arcball;

/**
 *
 * @author Martin Prout
 */
public enum Constrain {

    /**
     * Used to constrain arc-ball rotation about X axis
     */
    
    XAXIS(0),
    /**
     * Used to constrain arc-ball rotation about Y axis
     */
    YAXIS(1),
    /**
     * Used to constrain arc-ball rotation about Z axis
     */
    ZAXIS(2),
    /**
     * Used for default no constrain arc-ball about any axis
     */
    FREE(-1);
    private final int index;

    Constrain(int idx) {
        this.index = idx;
    }

    /**
     * Numeric value of constrained axis
     * @return
     */
    public int index() {
        return index;
    }
}
