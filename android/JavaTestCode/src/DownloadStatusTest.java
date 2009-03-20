

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;

public class DownloadStatusTest {

	/**
	 * @param statURL The URL to fetch and parse the output of 
	 */

	public String fetch(String statURL) {
		String line = "", returnHTML = "";
        try {
            //System.err.println("*** Loading " + statURL + "... ***");
            URL webURL = new URL(statURL);
            BufferedReader is = new BufferedReader(
                new InputStreamReader(webURL.openStream()));
            while ((line = is.readLine()) != null) {
                returnHTML = returnHTML + line;
            }
            is.close();
        } catch (MalformedURLException e) {
            System.err.println("Load failed: " + e);
        } catch (IOException e) {
            System.err.println("IOException: " + e);
        } // try
//        System.out.println("Downloaded status is:");
//        System.out.println(returnHTML);
        return returnHTML;
	} // public static void main(String[] args)
} // public static void main(String[] args)