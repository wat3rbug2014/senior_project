// Created by: Douglas Gardiner
// Creation Date: Thu Dec 24 12:43:35 CST 2009
// Update Date: Thu Dec 24 14:12:43 CST 2009
//

/* Does UDP listening
*/

import java.net.*;
import java.io.*;
import javax.swing.*;

public class UdpReceive extends TcpReceive {

    // class variables

    private static final boolean debug = false;
    // constructors

    public UdpReceive(JTextArea messageLog, String port) {

	super(messageLog, port);
    }
    // methods

    public void getMessage() {

	if (debug) System.out.println(" --- UdpReceive ---");
	DatagramSocket receiver = null;
	DatagramPacket message = null;
	byte[] msgBytes =new byte[1400];
	
	try {
	    if (debug) System.out.println(" --- waiting ---");
	    receiver = new DatagramSocket(port);
	    receiver.setSoTimeout(1000);
	    message = new DatagramPacket(msgBytes, 1400);
	    receiver.receive(message);
	    if (message.getLength() > 0 ) {
		log.append(new String(message.getData(), 0, 
				      message.getLength()) + "\n");
		if (debug) System.out.println(" --- heard message ---");
	    }
	} catch (SocketTimeoutException ste) {
	    if (debug) System.out.println(" --- timed out ---"); 
	} catch(SocketException se) {
	    // useless unless we want to debug
	    if (debug) se.printStackTrace();
	} catch (IOException ioe) {
	    // same deal
	    if (debug) ioe.printStackTrace();
	} finally {
	    if (receiver !=null && !receiver.isClosed()) receiver.close();
	}
    }
}
