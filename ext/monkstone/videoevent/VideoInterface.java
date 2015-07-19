package monkstone.videoevent;
import processing.video.Movie;
import processing.video.Capture;
/**
 * This interface makes it easier/possible to use the reflection methods
 * from Movie and Capture classes in Processing::App in ruby-processing
 * @author Martin Prout
 */
public interface VideoInterface {
    /**
     * Used to implement reflection method in PApplet
     * @see processing.video.Movie
     * @param movie Movie
     */
    void movieEvent(Movie movie);
    /**
     * Used to implement reflection method in PApplet
     * @see processing.video.Capture
     * @param capture Capture
     */
    void captureEvent(Capture capture);    
}
