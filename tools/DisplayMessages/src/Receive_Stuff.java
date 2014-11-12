// Created by: Douglas Gardiner
// Creation Date: Thu Dec 24 12:43:25 CST 2009
// Update Date: Thu Dec 24 14:11:24 CST 2009
//

/* This is the scheduler that handles what ports to listen to
and what protocol to use.  It is started as a new thread to
offload GUI handling.
*/

import javax.swing.*;

public class Receive_Stuff implements Runnable {

    // class variables

    JTextArea log = null;
    boolean tcp = true;
    String port = "10077";
    private static final boolean debug = false;
    private static boolean isRunning = true;

    // constructors

    public Receive_Stuff(JTextArea log, String port, boolean tcp) {

	this.log = log;
	this.port = port;
	this.tcp = tcp;
    }
    // methods

    public void run() {
		
	while (getRunning()) {
	    if (tcp) {
		if (debug) System.out.println(" --- Receive_Stuff ---\n" +
				      " --- Listening on TCP port " +
					  port + " ---");
		TcpReceive tcpListener = new TcpReceive(log, port);
		tcpListener.getMessage();
	    } else {
		if (debug) System.out.println(" --- Receive_Stuff ---\n" +
					      " --- Listening on UDP port " +
					      port + " ---");
		UdpReceive udpListener = new UdpReceive(log, port);
		udpListener.getMessage();
	    }
	    if (debug) System.out.println(" --- listener dies ---");
	    
	}
    }
    public synchronized void setRunning(boolean state) {

	isRunning = state;
    }
    public synchronized boolean getRunning() {

	return isRunning;
    }
}
