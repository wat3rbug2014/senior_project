// Created by: Douglas Gardiner
// Creation Date: 1261681995916
// Update Date: Thu Dec 24 13:49:55 CST 2009
//

/* This is the backend for the broadcaster.  It handles which
connection to start and when to start it.  It is a seperate
thread, so be watchful for concurrency issues when messing
with it.
*/

public class TransmitServer implements Runnable {

    // class variables

    String message = null;
    String host = null;
    String port = null;
    private static boolean keepRunning = false;
    private static final int SEC_LENGTH = 1000;
    private static long seconds = 6 * SEC_LENGTH;
    private static boolean tcp = true;
    private static boolean broadcast = false;
    private static final boolean debug = true;

    // constructors

    public TransmitServer(String message, String host, String port) {

	this.message = message;
	this.host= host;
	this.port = port;
    }
    // methods

    public void run() {

	if (debug) System.out.println(" --- TransmitServer ---");
	do  {
	    if (getTcp()) {
		if (debug) System.out.println(" --- sent message TCP to " +
					      port);
		Xmt_TCP burst = new Xmt_TCP(message, host, port);
		burst.openTheGates();
	    } else {
		if (debug) System.out.println(" --- sent message UDP to " +
					      port);
		Xmt_UDP burst = new Xmt_UDP(message, host, port);
		if (getBroadcast()) {
		    burst.setBroadcast(true);
		}
		burst.openTheGates();  	    
	    }
	    if (debug) System.out.println(" --- completed transmit ---");
	    Thread.yield();
	    try {
		Thread.sleep(seconds);
	    } catch (InterruptedException ie) {
		setRunning(false);
		return;
	    }
	} while (isRunning());
    }
    public synchronized void setRunning(boolean state) {

	keepRunning = state;
    }
    public synchronized boolean isRunning() {

	return keepRunning;
    }
    public synchronized void setTcp(boolean state) {

	// true = tcp, false = udp
	tcp = state;
    }
    public synchronized boolean getTcp() {

	return tcp;
    }
    public synchronized void setBroadcast(boolean state) {

	broadcast = state;
    }
    public synchronized boolean getBroadcast() {

	return broadcast;
    }
}
