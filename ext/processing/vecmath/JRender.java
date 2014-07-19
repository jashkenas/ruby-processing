package processing.vecmath;

/**
 *
 * @author Martin Prout
 */
public interface JRender {  
    public void vertex(double x, double y);
    public void vertex(double x, double y, double z);
    public void vertex(double x, double y, double z, double u, double v);
    public void normal(double x, double y, double z);
}
