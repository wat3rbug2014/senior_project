// Created by: Douglas Gardiner
// Creation Date: Thu Dec 24 12:44:55 CST 2009
// Update Date: Thu Dec 24 14:12:28 CST 2009
//

/* Does TCP listening
*/

import java.net.*;
import java.io.*;
import javax.swing.*;

public class TcpReceive {

    // class variables

    int port = 0;
    JTextArea log = null;
    private static final boolean debug = false;

    // constructors

    public TcpReceive(JTextArea messageLog, String port) {

	this.port = new Integer(port).intValue();
	log = messageLog;
    }
    // methods

    public void getMessage() {

	ServerSocket listen = null;
	Socket socket = null;
	BufferedReader reader;
	StringBuffer buffer = null;
	try {
	    if (debug) System.out.println(" --- TcpReceive ---\n" +
					  " --- waiting ---");
	    listen = new ServerSocket(port);
	    listen.setSoTimeout(1000);
	    socket = listen.accept();
	    if (debug) System.out.println(" --- heard message ---");
	    reader = new BufferedReader(new InputStreamReader 
	         (socket.getInputStream()));
	    String temp = null;
	    while ((temp = reader.readLine()) != null ) {
		log.append(temp + "\n");
	    }
	} catch (SocketTimeoutException ste) {
	    if (debug) {
		System.out.println(" --- timed out ---");
	    }
	} catch (IOException ioe) {

	    // cleanup bindings to ports

	    if (debug) {
		ioe.printStackTrace();
		System.out.println("wrong time out");
		try {
		    if (socket != null && !socket.isClosed()) {
			socket.close();
		    }
		    if (listen != null && !listen.isClosed()) {
			listen.close();
		    }
		} catch (IOException bio) {
		    // useless because we're only doing cleanup
		} 
	    }
	}finally {
	    if (debug) System.out.println(" --- closing socket ---");
	    try {
		if (socket != null && ! socket.isClosed()) {
		    socket.close();
		}
		if (listen != null && ! listen.isClosed()) {
		    listen.close();
		}
	    } catch (IOException bio) {
		// useless same reason as above
	    } 
	}
    }
}

