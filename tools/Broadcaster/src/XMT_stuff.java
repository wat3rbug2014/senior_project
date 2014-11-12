// Created by: Douglas Gardiner
// Creation Date: Thu Dec 24 12:57:28 CST 2009
// Update Date: Thu Dec 24 13:57:21 CST 2009
//

/* This is the base class that the other 2 IP protocol classes
use.  It's intent is to setup the object, and then the
subclasses, XMT_Udp, and XMT_Tcp will overload the transmit
methods.
*/

/* This is the super class to transmit from.  The attempt is to make things
   manageable by doing class overloading of methods
*/
import java.net.*;

public class XMT_stuff {

    // class variables

    protected InetAddress address;
    protected int port = 0;
    protected String message = null;
    protected static boolean okToRun = true;
    protected static boolean broadcast = false;
    protected static final boolean debug = false;

    // constructors

    public XMT_stuff() {}

    public XMT_stuff(String message, String address, String port) {

		this.message = message;
		this.port = new Integer(port).intValue();
		try {
	    	this.address = InetAddress.getByName(address);
	    	okToRun = true;
		} catch (UnknownHostException uhe) {
	    	okToRun = false;
		}
    }
    // methods
 
    public void openTheGates() {

    }
}
