// Created by: Douglas Gardiner
// Creation Date: Thu Dec 24 13:03:40 CST 2009
// Update Date: Thu Dec 24 13:58:59 CST 2009
//

/* This class handles UDP transmissions.
*/

import java.net.*;
import java.io.*;

public class Xmt_UDP extends XMT_stuff {

    // use super class constructors

    public Xmt_UDP(String message, String address, String port) {

	super(message, address, port);
    }
    // methods

    public void openTheGates() {

	DatagramSocket transmitter = null;
	DatagramPacket output = null;
	try {
	    transmitter = new DatagramSocket();
	    transmitter.setBroadcast(broadcast);
	    transmitter.connect(address, port);
	    byte[] sendBuff = message.getBytes();
	    output = new DatagramPacket(sendBuff, sendBuff.length);
	    transmitter.send(output);
	    transmitter.close();
	} catch (NoRouteToHostException nrthee) {
	    if (debug) nrthee.printStackTrace();
	} catch (SocketException se) {
	    if (debug) se.printStackTrace();
	} catch (IOException nrthe ) {
	    if (debug) nrthe.printStackTrace();
	} finally {
	    if (transmitter != null && !transmitter.isClosed()) {
		transmitter.close();
	    }
	}
    }
    public void setBroadcast(boolean broadcast) {

	XMT_stuff.broadcast = broadcast;
    }
}
