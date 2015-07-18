/**
 * The purpose of this library is to allow users to use ArcBall in processing
 * sketches Copyright (C) 2014 Martin Prout This library is free software; you
 * can redistribute it and/or modify it under the terms of the GNU Lesser
 * General Public License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
* Obtain a copy of the license at http://www.gnu.org/licenses/lgpl-2.1.html
 */

/*
 * CREDITS...Initially I found this arcball in a sketch by Ariel Malka, 
 * only later did I find the Tom Carden processing tutorial example, so take your pick 
 * 
 * 1) Ariel Malka - June 23, 2003 http://www.chronotext.org
 * 
 * 2) Simon Greenwold? 2003 (as reported 2006 by Tom Carden http://wiki.processing.org/w/Arcball)
 *
 * 3) JarcBall concept invented by Ken Shoemake, published in his 1985 SIGGRAPH paper "Animating rotations with quaternion curves". 
 * 
 * 4) Somewhat modified by Martin Prout to support callbacks from processing sketch
 **/
package processing.vecmath.arcball;

import processing.core.PApplet;
import processing.event.KeyEvent;
import processing.event.MouseEvent;

/**
 * Supports the JarcBall and MouseWheel zoom manipulation of objects in
 * processing
 * 
* @author Martin Prout
 */
public final class JarcBall {

    private double center_x;
    private double center_y;
    private double radius;
    private Jvector v_down;
    private Jvector v_drag;
    private Quaternion q_now;
    private Quaternion q_down;
    private Quaternion q_drag;
    private Jvector[] axisSet;
    private Constrain axis;
    private boolean isActive = false;
    private final PApplet parent;
    private double zoom = 1.0;
    private final WheelHandler zoomWheelHandler;
    private boolean camera = false;
    final float DEPTH = (float) (1 / (2 * Math.tan(Math.PI / 6)));

    /**
     *
     * @param parent PApplet
     * @param center_x double x coordinate of arcball center
     * @param center_y double y coordinate of arcball center
     * @param radius double radius of arcball
     */
    public JarcBall(final PApplet parent, float center_x, float center_y, float radius) {
        this.zoomWheelHandler = new WheelHandler() {
            @Override
            public void handleWheel(final int delta) {
                zoom += delta * 0.05;
            }
        };
        this.parent = parent;
        this.center_x = center_x;
        this.center_y = center_y;
        this.radius = radius;
        this.v_down = new Jvector();
        this.v_drag = new Jvector();
        this.q_now = new Quaternion();
        this.q_down = new Quaternion();
        this.q_drag = new Quaternion();
        this.axisSet = new Jvector[]{new Jvector(1.0, 0.0, 0.0), new Jvector(0.0, 1.0, 0.0), new Jvector(0.0, 0.0, 1.0)};
        this.axis = Constrain.FREE; // no constraints...

    }

    /**
     * Default centered arcball and half width or half height whichever smaller
     *
     * @param parent
     *
     */
    public JarcBall(final PApplet parent) {
        // this(parent, parent.width / 2.0f, parent.height / 2.0f, Math.min(parent.width, parent.height) * 0.5f);
        this(parent, 0, 0, Math.min(parent.width, parent.height) * 0.8f);
        parent.camera(parent.width / 2.0f, parent.height / 2.0f, parent.height * DEPTH, 0, 0, 0, 0, 1.0f, 0);
        camera = true;
        this.axis = Constrain.FREE; // no constraints...
    }

    /**
     * mouse event to register
     *
     * @param e
     */
    public void mouseEvent(MouseEvent e) {
        int x = e.getX();
        int y = e.getY();
        switch (e.getAction()) {
            case (MouseEvent.PRESS):
                v_down = mouse2sphere(x, y);
                q_down.set(q_now);
                q_drag.reset();
                break;
            case (MouseEvent.DRAG):
                v_drag = mouse2sphere(x, y);
                q_drag.set(v_down.dot(v_drag), v_down.cross(v_drag));
                break;
            case (MouseEvent.WHEEL):
                if (zoomWheelHandler != null) {
                    zoomWheelHandler.handleWheel(e.getCount());
                }
                break;
            default:
        }
    }

    /**
     * key event to register
     *
     * @param e
     */
    public void keyEvent(processing.event.KeyEvent e) {
        if (e.getAction() != KeyEvent.PRESS) {
        } else {
            switch (e.getKey()) {
                case 'x':
                    constrain(Constrain.XAXIS);
                    break;
                case 'y':
                    constrain(Constrain.YAXIS);
                    break;
                case 'z':
                    constrain(Constrain.ZAXIS);
                    break;
            }
        }
        if (e.getAction() == KeyEvent.RELEASE) {
            constrain(Constrain.FREE);
        }
    }

    /**
     *
     */
    public void pre() {
        if (!camera) {
            parent.translate((float) center_x, (float) center_y);
        }
        update();
    }

    /**
     * May or may not be required for use in Web Applet it works so why worry as
     * used by Jonathan Feinberg peasycam, and that works OK
     *
     * @param active
     */
    public final void setActive(boolean active) {
        if (active != isActive) {
            isActive = active;
            if (active) {
                this.parent.registerMethod("dispose", this);
                this.parent.registerMethod("pre", this);
                this.parent.registerMethod("mouseEvent", this);
                this.parent.registerMethod("keyEvent", this);

            } else {
                this.parent.unregisterMethod("pre", this);
                this.parent.unregisterMethod("mouseEvent", this);
                this.parent.unregisterMethod("keyEvent", this);
            }
        }
    }

    /**
     * Don't call this directly in sketch use reflection to call in eg in pre()
     */
    private void update() {
        q_now = Quaternion.mult(q_drag, q_down);
        applyQuaternion2Matrix(q_now);
        parent.scale((float) zoom);
    }

    /**
     * Returns either the Jvector of mouse position mapped to a sphere or
     * the constrained version (when constrained to one axis) 
     * @param x
     * @param y
     * @return mouse coordinate mapped to unit sphere
     */
    public Jvector mouse2sphere(double x, double y) {
        Jvector v = new Jvector((x - center_x) / radius, (y - center_y) / radius, 0);
        double mag_sq = v.x * v.x + v.y * v.y; 
        if (mag_sq > 1.0) {
            v.normalize(); 
        } else {
            v.z = Math.sqrt(1.0 - mag_sq);
        }
        if (axis != Constrain.FREE) {
            v = constrainVector(v, axisSet[axis.index()]);
        }
        return v;
    }

    /**
     * Returns the Jvector if the axis is constrained
     *
     * @param vector
     * @param axis
     * @return
     */
    public Jvector constrainVector(Jvector vector, Jvector axis) {
        Jvector res = vector.sub(axis.mult(axis.dot(vector)));
        return res.normalize(); // like Jvector res is changed
    }

    /**
     * Constrain rotation to this axis
     *
     * @param axis
     */
    public void constrain(Constrain axis) {
        this.axis = axis;
    }

    /**
     * Rotate the parent sketch according to the quaternion
     *
     * @param q
     */
    public void applyQuaternion2Matrix(Quaternion q) {
        // instead of transforming q into a matrix and applying it...
        double[] aa = q.getValue();
        parent.rotate((float) aa[0], (float) aa[1], (float) aa[2], (float) aa[3]);
    }

    /**
     * A recommended inclusion for a processing library
     */
    public void dispose() {
        setActive(false);
    }
}
