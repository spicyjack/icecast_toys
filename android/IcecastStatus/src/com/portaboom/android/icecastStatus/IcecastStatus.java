package com.portaboom.android.icecastStatus;

/**
 * $Id$
 * 
 * @author elspicyjack at gmail dot com
 * @version $Revision$
 *
 * NOTE: Please do not e-mail the author directly regarding this code.  
 * The proper forum for support is the Streambake Google Groups list at
 * http://groups.google.com/group/streambake or <streambake@groups.google.com>
 * 
*/

/* FIXME
- Pass this object in to the downloader and parser so that they can make
  callbacks when needed
*/

// android imports
import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.widget.ScrollView;
import android.widget.TextView;
import android.widget.Toast;

public class IcecastStatus extends Activity {
        static final String TAG = "IcecastStatus";
        // FIXME abstract this; the user should be able to enter
        // the server name and port in a dialog somewhere
        // and different URL's can be tried in the order of most
        // preferred to least preferred until a URL is found that
        // doesn't 404
        String statURL = "http://stream.portaboom.com:7767/simple.xsl";
        String fetchedText = "";

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.v(TAG, "starting onCreate; statURL is " + statURL);
        try {
        	HTTPStatusDownload hsd = new HTTPStatusDownload();
        	fetchedText = hsd.fetch(statURL);
        } catch (Throwable t) {
        	Toast 
            .makeText(this, "Request failed: " + t.toString(), 4000);
            //.show();
        }

        // create the output text box
        ParseStatus pst = new ParseStatus();
        TextView tv = new TextView(this);
        tv.setText( "Status URL: " + statURL + "\n" + pst.parse( fetchedText ) );
        ScrollView sv = new ScrollView(this);
        sv.addView(tv);
        setContentView(sv);
        //Object o = null;
        //o.toString();
        //setContentView(R.layout.main);
    }
}

