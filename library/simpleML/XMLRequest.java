package simpleML;

import processing.core.*;
import java.lang.reflect.*;
import java.util.ArrayList;

import news.A2ZXmlReader;

import org.w3c.dom.Element;
import org.w3c.dom.Node;

public class XMLRequest implements Runnable {

    PApplet parent;
    Method eventMethod;
    Thread runner;
    boolean available = false;
    String url;
    A2ZXmlReader xmlReader;

    public XMLRequest(PApplet parent, String url_) {
        this.parent = parent;
        this.url = url_;
        parent.registerDispose(this);
        try {
            eventMethod = parent.getClass().getMethod("netEvent", new Class[] { 
                    XMLRequest.class             }
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
    
    public String getElementText(String tag) {
        Element e = xmlReader.findElement(xmlReader.getRoot(),tag);
        if (e != null) {
            Node n = e.getFirstChild();
            return n.getNodeValue();
        } else {
            return "Element not found";
        }
    }
    
    public String getElementAttributeText(String tag, String attr) {
        Element e = xmlReader.findElement(xmlReader.getRoot(),tag);
        if (e != null) {
            // Pull out the attributes we are looking for from that element
           return  e.getAttribute(attr);
        } else {
            return "Element attribute not found";
        }
    }
    
    public String[] getElementArray(String tag) {
        ArrayList elements = new ArrayList();
        xmlReader.fillArrayList(xmlReader.getRoot(),tag,elements);

        String[] stuff = new String[elements.size()];
        for (int i = 0; i < stuff.length; i++) {
            Element e = (Element) elements.get(i);
            // As long as we find the element
            if (e != null) {
                Node n = e.getFirstChild();
                stuff[i] = n.getNodeValue();
            } else {
                stuff[i] = "Element not found";
            }
        }
        return stuff; 
    }


    public void run() {
        try {
            xmlReader = new A2ZXmlReader(url);
            
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
