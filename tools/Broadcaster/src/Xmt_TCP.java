// Created by: Douglas Gardiner
// Creation Date: Thu Dec 24 12:59:03 CST 2009
// Update Date: Thu Dec 24 13:58:41 CST 2009
//

/* This class handles TCP transmissions.
*/

import java.net.*;
import java.io.*;

public class Xmt_TCP extends XMT_stuff {

    // use super class constructors

    public Xmt_TCP(String message, String address, String port) {

	super(message, address, port);
    }
    // methods

    public void openTheGates() {

	Socket transmitter = null;
	DataOutputStream output = null;
	try {
	    transmitter = new Socket(address, port);
	    output = new DataOutputStream(transmitter.getOutputStream());
	    output.writeBytes(message);
	    output.flush();
	    transmitter.close();
	} catch (NoRouteToHostException nrthe) {
	    if (debug) nrthe.printStackTrace();
	} catch (IOException ioe ) {
	    if (debug) ioe.printStackTrace();
	} finally {
	    if (! transmitter.isClosed()) { 
		try {
		    transmitter.close();
		} catch (IOException boe) {
		    // bad hack ignore error, you're closing it
		}
	    }
	}
    }
}
