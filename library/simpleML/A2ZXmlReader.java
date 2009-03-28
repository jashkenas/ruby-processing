/* Daniel Shiffman               */
/* Programming from A to Z       */
/* Spring 2006                   */
/* http://www.shiffman.net       */
/* daniel.shiffman@nyu.edu       */

/* Class to search / traverse an  */
/* XML file                       */


package simpleML;
import java.net.*;
import java.util.ArrayList;
import java.io.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class A2ZXmlReader
{
    private String urlPath;
    private Document doc;
    private Element root;
    
    public A2ZXmlReader(String name) throws IOException {
        urlPath = name;
        try {
            createDocument();
        } catch (ParserConfigurationException e) {
            e.printStackTrace();
        } catch (SAXException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    public void createDocument() throws ParserConfigurationException, SAXException, IOException {
        InputStream is = openStream(urlPath);
        DocumentBuilderFactory docBuilderFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder docBuilder = docBuilderFactory.newDocumentBuilder();
        doc = docBuilder.parse(is);
        doc.getDocumentElement().normalize();  // // strips out empty "text" nodes?
        
        root = doc.getDocumentElement();
    }
    
    public Element getRoot() {
        return root;
    }
    
    //	 This method recursively traverses the XML Tree (starting from currElement)
    public void traverseXML (Node currNode)
    {
        // If it's an Element, spit out the Name
        if (currNode.getNodeType() == Node.ELEMENT_NODE) {
            System.out.print(currNode.getNodeName() + ": ");
            // If it's a "Text" node, take the value
            // These will come one after another and therefore appear in the right order
        } else if (currNode.getNodeType() == Node.TEXT_NODE) {
            System.out.println(currNode.getNodeValue().trim());
        }
        
        // Display any attributes
        if (currNode.hasAttributes()) {
            NamedNodeMap attributes = currNode.getAttributes();
            for (int i = 0; i < attributes.getLength(); i++) {
                Node attr = attributes.item(i);
                System.out.println("  " + attr.getNodeName() + ": " + attr.getNodeValue());
            }
        }
        
        // Check any children
        if (currNode.hasChildNodes()) {
            // Get the list of children
            NodeList children = currNode.getChildNodes();
            // Go through all the chilrden
            for (int i = 0; i < children.getLength(); i++) {
                // Search each Node
                Node n = children.item(i);
                traverseXML(n);
            }
        }
    }
    
    // This method recursively searches for an Element (starting from currElement) with the name elementName
    public Element findElement(Element currElement, String elementName)
    {
        // So far we've found nothing, i.e. null
        Element found = null;
        // If the current element is what we want, hooray we are done!
        if (currElement.getTagName().equals(elementName)) {
            found = currElement;
            // Otherwise, if there are children, let's check those
        } else if (currElement.hasChildNodes()) {
            // Get the list of children
            NodeList children = currElement.getChildNodes();
            // As long as we haven't found it (i.e. found is still null)
            for (int i = 0; i < children.getLength() && found == null; i++) {
                // Search each Element type node
                Node n = children.item(i);
                if (n.getNodeType() == Node.ELEMENT_NODE) {
                    Element e = (Element) n;
                    found = findElement(e, elementName);
                }
            }
        }
        return found;
    }   
    
    
    // Find all elements
    public void fillArrayList(Element currElement, String elementName, ArrayList a) {
        // So far we've found nothing, i.e. null
        Element found = null;
        // If the current element is what we want, hooray we are done!
        if (currElement.getTagName().equals(elementName)) {
            found = currElement;
            // Otherwise, if there are children, let's check those
        } else if (currElement.hasChildNodes()) {
            // Get the list of children
            NodeList children = currElement.getChildNodes();
            // As long as we haven't found it (i.e. found is still null)
            for (int i = 0; i < children.getLength(); i++) {
                // Search each Element type node
                Node n = children.item(i);
                if (n.getNodeType() == Node.ELEMENT_NODE) {
                    Element e = (Element) n;
                    fillArrayList(e, elementName,a);
                }
            }
        }
        if (found != null) a.add(found);
    }
        
    
    

    
    
    private InputStream openStream(String urlpath) {
        InputStream stream = null;
        try {
            URL url = new URL(urlpath);
            stream = url.openStream();
            return stream;
        } catch (MalformedURLException e) {
            System.out.println("Something's wrong with the URL:  "+ urlpath);
            e.printStackTrace();
        } catch (IOException e) {
            System.out.println("there's a problem downloading from:  "+ urlpath);
            e.printStackTrace();
        }
        return stream;
    }

    
}



