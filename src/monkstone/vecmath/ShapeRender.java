package monkstone.vecmath;

import processing.core.PShape;

/**
 *
 * @author Martin Prout
 */
public class ShapeRender implements JRender {

    final PShape shape;

    /**
     *
     * @param shape
     */
    public ShapeRender(final PShape shape) {
        this.shape = shape;

    }

    /**
     *
     * @param x
     * @param y
     */
    @Override
    public void vertex(double x, double y) {
        shape.vertex((float) x, (float) y);
    }
    
    /**
     *
     * @param x
     * @param y
     */
    @Override
    public void curveVertex(double x, double y) {
        throw new UnsupportedOperationException("Not implemented for this renderer");
    }

    /**
     *
     * @param x
     * @param y
     * @param z
     */
    @Override
    public void vertex(double x, double y, double z) {
        shape.vertex((float) x, (float) y, (float) z);
    }

    /**
     *
     * @param x
     * @param y
     * @param z
     */
    @Override
    public void normal(double x, double y, double z) {
        shape.normal((float) x, (float) y, (float) z);
    }

    /**
     *
     * @param x
     * @param y
     * @param z
     * @param u
     * @param v
     */
    @Override
    public void vertex(double x, double y, double z, double u, double v) {
        shape.vertex((float) x, (float) y, (float) z, (float) u, (float) v);
    }
    
    /**
     *
     * @param x
     * @param y
     * @param z
     */
    @Override
    public void curveVertex(double x, double y, double z) {
        throw new UnsupportedOperationException("Not implemented for this renderer");
    }
}
