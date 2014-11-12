// Created by: Douglas Gardiner
// Creation Date: Thu Dec 24 13:37:34 CST 2009
// Update Date: Sat Nov 22 18:05:23 CST 2008
//

/* Main Class File for the Broadcaster tool.  It handles the
display.  The rest is offloaded to a thread class to keep up
with the details.
*/

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Broadcaster {

    // class variables

    public JFrame frame;
    public JTextField hostname;
    public JTextArea messageContents;
    public JTextField port;
    public ButtonGroup protocolType;
    public JRadioButton tcp;
    public JCheckBox broadcast;
    public boolean continuous = false;
    public JCheckBox selectContinue;
    public JButton triggerBroadcast;
    private static final boolean debug = true;


    // constructors

    public Broadcaster() {

	// initial vairables for GUI

	JLabel hostLabel = new JLabel("Host / IP");
	hostname = new JTextField("255.255.255.255",20);
	JLabel portLabel = new JLabel("Port");
	port = new JTextField("10077", 6);
	tcp = new JRadioButton("TCP", false);
	JRadioButton udp = new JRadioButton("UDP", true);
	messageContents = new JTextArea(5,15);
	broadcast = new JCheckBox("Broadcast Address");
	selectContinue = new JCheckBox("Continuous");
	triggerBroadcast = new JButton("Start");
	JScrollPane messageScroller = new JScrollPane(messageContents);

	// left side

	protocolType = new ButtonGroup();
	protocolType.add(tcp);
	protocolType.add(udp);
	JPanel radioPanel = new JPanel();
	radioPanel.setLayout(new GridLayout(3,2));
	radioPanel.add(hostLabel);
	radioPanel.add(hostname);
	radioPanel.add(portLabel);
	radioPanel.add(port);
	radioPanel.add(tcp);
	radioPanel.add(udp);
	radioPanel.setBorder(BorderFactory.createTitledBorder(BorderFactory.createEtchedBorder(), "Destination"));

	// middle panel 

	JPanel messagePanel = new JPanel();
	messagePanel.add(messageScroller);
	messagePanel.setBorder(BorderFactory.createTitledBorder(BorderFactory.createEtchedBorder(), "Message"));
	messageScroller.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
	messageScroller.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
	messageContents.setLineWrap(true);
	messageContents.setWrapStyleWord(true);

	// right side

	JPanel rightSide = new JPanel();
	rightSide.add(broadcast);
	rightSide.add(selectContinue);
	rightSide.add(triggerBroadcast);
	rightSide.setLayout(new GridLayout(3,1));

	// action listeners

	triggerBroadcast.addActionListener(new SendIt());

	// add components

	frame = new JFrame("Broadcaster");
	BorderLayout layout = new BorderLayout();
	JPanel background = new JPanel(layout);
	JPanel contents = new JPanel();
	contents.setLayout(new GridLayout(1,3));
	background.setBorder(BorderFactory.createEmptyBorder(10,10,10,10));
	contents.add(radioPanel);
	contents.add(messagePanel);
	contents.add(rightSide);
	background.add(contents);
	frame.getContentPane().add(background);
	frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	SwingUtilities.updateComponentTreeUI(frame);
	frame.setSize(700,175);
	frame.setVisible(true);
    }
    // methods

    public static void main(String[] args) {

	new Broadcaster();
    }
    // inner classes

    public class SendIt implements ActionListener {

		public void actionPerformed(ActionEvent ae) {

	    	String messageToUse = messageContents.getText();
	    	String portToUse = port.getText();
	    	String host = hostname.getText();
	    	TransmitServer transmitter = new TransmitServer(messageToUse, host, portToUse);
	    	transmitter.setBroadcast(broadcast.isSelected());
	    	transmitter.setTcp(tcp.isSelected());
	    	transmitter.setRunning(selectContinue.isSelected());
	    	Thread server = new Thread(transmitter, "Server");
	    	if (selectContinue.isSelected()) {
				if (debug) System.out.println(" --- in continuous mode ---");
				if (triggerBroadcast.getText().equals("Stop")) {
		    		transmitter.setRunning(false);
		    		server.interrupt();
		    		try {
						server.join();
		    		} catch (InterruptedException ie) {

		    		}
		    		triggerBroadcast.setText("Start");
				} else {
		    		triggerBroadcast.setText("Stop");
				} 
	    	} else {
				if (debug) System.out.println(" --- left continuous mode ---");
				triggerBroadcast.setText("Start");
				transmitter.setRunning(false);
				server.interrupt();
				try {
		    		server.join();
				} catch(InterruptedException ie) {
		    		// i need it interrupted
				}
	    	}
	    	server.start();
		}				    
    }
}
