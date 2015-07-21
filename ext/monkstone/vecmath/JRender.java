package monkstone.vecmath;

/**
 *
 * @author Martin Prout
 */
public interface JRender {  

    /**
     *
     * @param x
     * @param y
     */
    public void vertex(double x, double y);

    /**
     *
     * @param x
     * @param y
     */
    public void curveVertex(double x, double y);

    /**
     *
     * @param x
     * @param y
     * @param z
     */
    public void vertex(double x, double y, double z);

    /**
     *
     * @param x
     * @param y
     * @param z
     * @param u
     * @param v
     */
    public void vertex(double x, double y, double z, double u, double v);

    /**
     *
     * @param x
     * @param y
     * @param z
     */
    public void curveVertex(double x, double y, double z);

    /**
     *
     * @param x
     * @param y
     * @param z
     */
    public void normal(double x, double y, double z);
}
