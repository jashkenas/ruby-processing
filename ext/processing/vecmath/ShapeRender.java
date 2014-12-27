package processing.vecmath;

import processing.core.PShape;

/**
 *
 * @author Martin Prout
 */
public class ShapeRender implements JRender {

    final PShape shape;

    public ShapeRender(final PShape shape) {
        this.shape = shape;

    }

    @Override
    public void vertex(double x, double y) {
        shape.vertex((float) x, (float) y);
    }
    
    @Override
    public void curveVertex(double x, double y) {
        throw new UnsupportedOperationException("Not implemented for this renderer");
    }

    @Override
    public void vertex(double x, double y, double z) {
        shape.vertex((float) x, (float) y, (float) z);
    }

    @Override
    public void normal(double x, double y, double z) {
        shape.normal((float) x, (float) y, (float) z);
    }

    @Override
    public void vertex(double x, double y, double z, double u, double v) {
        shape.vertex((float) x, (float) y, (float) z, (float) u, (float) v);
    }
    
    @Override
    public void curveVertex(double x, double y, double z) {
        throw new UnsupportedOperationException("Not implemented for this renderer");
    }


}
