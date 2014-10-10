// Created by: Douglas Gardiner
// Creation Date: Thu Dec 24 13:32:15 CST 2009
// Update Date: Thu Dec 24 14:07:41 CST 2009
//

/* This is the base class for the program.  Its intent is to be
able to listen to specific ports after translating for
testing applications.  This file does the GUI setup and then
does the handoff to the thread backend for listening.
*/

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class DisplayMessages {


    // class variables

    JFrame frame;
    JTextField portField;
    JButton listen;
    JRadioButton tcp;
    JTextArea messageContents;
    private boolean keepListening = false;
    private static boolean debug = false;

    // constructors

    public DisplayMessages() {

	// setup labels and fields

	JLabel portLabel = new JLabel("Port");
	portField = new JTextField("10077",10);
	tcp = new JRadioButton("TCP", true);
	JRadioButton udp = new JRadioButton("UDP", false);
	messageContents = new JTextArea(5,20);
	listen = new JButton("Listen");
	JButton clear = new JButton("Clear Display");
	JScrollPane messageScroller = new JScrollPane(messageContents);
	ButtonGroup protocolType = new ButtonGroup();

	// area groupings

	// left side

	JPanel portPanel = new JPanel();
	portPanel.add(portLabel);
	portPanel.add(portField);
	JPanel protocolPanel = new JPanel();
	protocolPanel.add(tcp);
	protocolPanel.add(udp);
	protocolType.add(tcp);
	protocolType.add(udp);
	JPanel setupPanel = new JPanel();
	setupPanel.setLayout(new GridLayout(3,1));		     
	setupPanel.add(portPanel);
	setupPanel.add(protocolPanel);
	JPanel buttonPanel = new JPanel();
	buttonPanel.add(listen);
	buttonPanel.add(clear);
	setupPanel.add(buttonPanel);

	// right side

	JPanel messagePanel = new JPanel();
	messagePanel.add(messageScroller);
	messagePanel.setBorder(BorderFactory.createTitledBorder(
	     BorderFactory.createEtchedBorder(), "Message"));
	messageScroller.setHorizontalScrollBarPolicy(
	     ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
	messageScroller.setVerticalScrollBarPolicy(
	     ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
	messageContents.setLineWrap(true);
	messageContents.setWrapStyleWord(true);

	// action listeners

	listen.addActionListener(new TriggerListener());
	clear.addActionListener(new CleanUp());

	// tie everything together

	frame = new JFrame("Listener");
	BorderLayout layout = new BorderLayout();
	JPanel background = new JPanel(layout);
	JPanel contents = new JPanel();
	contents.setLayout(new GridLayout(1,3));
	background.setBorder(BorderFactory.createEmptyBorder(10,10,10,10));
	contents.add(setupPanel);
	contents.add(messagePanel);
	background.add(contents);
	frame.getContentPane().add(background);
	frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	SwingUtilities.updateComponentTreeUI(frame);
	frame.setSize(600,170);
	frame.setVisible(true);
    }

    // methods

    public static void main(String[] args ) {


	DisplayMessages test = new DisplayMessages();
    }
    // inner classes

    public class CleanUp implements ActionListener {

	public void actionPerformed(ActionEvent ae) {

	    messageContents.setText("");
	}
    }
    public class TriggerListener implements ActionListener {

	public void actionPerformed(ActionEvent ae) {

	    Receive_Stuff receiver = new Receive_Stuff(messageContents, 
		 portField.getText(), tcp.isSelected());
	    Thread server = new Thread(receiver, "Server");   
 
		if (debug) System.out.println(" --- DisplayMessage ---\n" +
					      " --- killing old process ---");
		
		receiver.setRunning(false);
		server.interrupt();
		try {
		    server.join();
		} catch (InterruptedException ie) {
		    // i hope so, I'm trying to interrupt operation
		}
		// } 
		try {
		    Thread.sleep(1000);
		} catch (InterruptedException ie) {
		    // nothing to do
		}
		receiver.setRunning(true);
	    server.start();
	    if (debug) System.out.println(" --- started listener ---");
	}
    }
}
