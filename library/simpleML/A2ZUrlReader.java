/* Daniel Shiffman               */
/* Programming from A to Z       */
/* Spring 2006                   */
/* http://www.shiffman.net       */
/* daniel.shiffman@nyu.edu       */

/* Class to read an input file   */
/* and return a String           */

package simpleML;
import java.net.*;
import java.io.*;

public class A2ZUrlReader
{
	private String urlPath;
	private String content;
	
	public A2ZUrlReader(String name) throws IOException {
		urlPath = name;
		readContent();
	}
	
	
	public static InputStream openStream(String urlpath) {
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
	
	
	public void readContent() throws IOException {
		StringBuffer stuff = new StringBuffer();
		try {
			InputStream stream = openStream(urlPath);
			BufferedReader reader = new BufferedReader(new InputStreamReader(stream));
			String line;
			while (( line = reader.readLine()) != null) {
				stuff.append(line + "\n");
			}
			reader.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		content = stuff.toString();
	}
	
	public String getContent() {
		return content;
	}
}



