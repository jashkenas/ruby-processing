package processing.vecmath;

import processing.core.PApplet;

/**
 *
 * @author Martin Prout
 */
public class AppRender implements JRender {

    final PApplet app;

    public AppRender(final PApplet app) {
        this.app = app;
    }

    @Override
    public void vertex(double x, double y) {
        app.vertex((float) x, (float) y);
    }

    @Override
    public void vertex(double x, double y, double z) {
        app.vertex((float) x, (float) y, (float) z);
    }

    @Override
    public void normal(double x, double y, double z) {
        app.normal((float) x, (float) y, (float) z);
    }

    @Override
    public void vertex(double x, double y, double z, double u, double v) {
        app.vertex((float) x, (float) y, (float) z, (float) u, (float) v);
    }

}
