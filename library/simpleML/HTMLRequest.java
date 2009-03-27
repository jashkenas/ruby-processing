package simpleML;

import processing.core.*;
import java.lang.reflect.*;

public class HTMLRequest implements Runnable {

    PApplet parent;
    Method eventMethod;
    Thread runner;
    boolean available = false;
    String text;
    String url;

    public HTMLRequest(PApplet parent, String url_) {
        this.parent = parent;
        this.text = "";
        this.url = url_;
        parent.registerDispose(this);
        try {
            eventMethod = parent.getClass().getMethod("netEvent", new Class[] { 
                    HTMLRequest.class             }
            );
        } 
        catch (Exception e) {
            //System.out.println("Hmmm, event method no go?");
        }
    }
    
    public void makeRequest() {
        runner = new Thread(this);
        runner.start();
    }
    
    public boolean available() {
        return available;
    }


    public String readRawSource() {
        available = false;
        return text;
    }


    public void run() {
        try {
            A2ZUrlReader urlReader = new A2ZUrlReader(url);
            text = urlReader.getContent();
            available = true;
            if (eventMethod != null) {
                try {
                    eventMethod.invoke(parent, new Object[] { 
                            this                     }
                    );
                } 
                catch (Exception e) {
                    System.err.println("Oopsies.");
                    e.printStackTrace();
                    eventMethod = null;
                }
            }
        } catch (Exception e) {

        }
    }

    /**
     * Called by applets to stop.
     */
    public void stop() {
        runner = null; // unwind the thread
    }

    /**
     * Called by PApplet to shut down
     */
    public void dispose() {
        stop();
        System.out.println("calling dispose");
    }

}
