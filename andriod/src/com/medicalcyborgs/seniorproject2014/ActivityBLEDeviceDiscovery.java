package com.medicalcyborgs.seniorproject2014;

import android.os.Bundle;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import java.util.Set;
import android.content.Intent;
import android.content.IntentFilter;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ProgressBar;;

public class ActivityBLEDeviceDiscovery extends Activity {

	// Elements
	private TextView text;
	private ListView DeviceListView;
	private ProgressBar DeviceProgressBar;
	
	// BlueTooth LE
	private BluetoothAdapter DeviceBluetoothAdapter;
	//private Set<BluetoothDevice> DeviceList;
	private ArrayAdapter<String> BTArrayAdapter;
	
	//private static final int REQUEST_ENABLE_BT = 1;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_ble_discovery);
		
		// Get BlueTooth Adapter
		DeviceBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
		
		// Check if device has supports BlueTooth
		if(DeviceBluetoothAdapter != null) {
			
			if( DeviceBluetoothAdapter.isEnabled() ) {
				
				
			} else {
				// Turn on BlueTooth if it's off (Device may prompt user)
				DeviceBluetoothAdapter.enable();
			}
			
			// Get Elements
			text = (TextView)findViewById(R.id.BLEDD_Text);
			DeviceProgressBar = (ProgressBar)findViewById(R.id.BLEDD_ProgressBar);
			
			/*onBtn = (Button)findViewById(R.id.turnOn);
			onBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				enableBlueTooth(v);
			}
			});
			
			offBtn = (Button)findViewById(R.id.turnOff);
			offBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				off(v);
			}
			});
			
			listBtn = (Button)findViewById(R.id.paired);
			listBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				list(v);
			}
			});
			
			findBtn = (Button)findViewById(R.id.search);
			findBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				find(v);
			}
			});*/
		 
			DeviceListView = (ListView)findViewById(R.id.BLEDD_ListView);
	
			// Device List
			BTArrayAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1);
			DeviceListView.setAdapter(BTArrayAdapter);
			
			// Begin Search for Devices
			searchForDevices();
		} else {
			text.setText("BlueTooth not supported!");
				
			Toast.makeText(getApplicationContext(),"Your device does not support Bluetooth!", Toast.LENGTH_LONG).show();
		}
	}

	/*public void enableBlueTooth(View view){
		if (!DeviceBluetoothAdapter.isEnabled()) {
			Intent turnOnIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
			startActivityForResult(turnOnIntent, REQUEST_ENABLE_BT);

			Toast.makeText(getApplicationContext(),"Bluetooth turned on" ,
				 Toast.LENGTH_LONG).show();
		}
		else{
			Toast.makeText(getApplicationContext(),"Bluetooth is already on",
				 Toast.LENGTH_LONG).show();
		}
	}*/
	
	/*@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		
		System.out.println("onActivityResult()");
		
		if(requestCode == REQUEST_ENABLE_BT){
			if(DeviceBluetoothAdapter.isEnabled()) {
				text.setText("Status: Enabled");
			} else {	
				text.setText("Status: Disabled");
			}
		}
	}*/
	
	/*public void list(View view){
		DeviceList = DeviceBluetoothAdapter.getBondedDevices();
		
		// put it's one to the adapter
		for(BluetoothDevice device : DeviceList)
			BTArrayAdapter.add(device.getName()+ "\n" + device.getAddress());

		Toast.makeText(getApplicationContext(),"Show Paired Devices",
			Toast.LENGTH_SHORT).show();
		
	}*/
	
	final BroadcastReceiver bReceiver = new BroadcastReceiver() {
		 public void onReceive(Context context, Intent intent) {
			String action = intent.getAction();
			
			// Device Found
			if (BluetoothDevice.ACTION_FOUND.equals(action)) {
				BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
				
				System.out.println("Found Device! " + device.getName());
				
				// Add device and MAC address to list
				BTArrayAdapter.add(device.getName() + "\n" + device.getAddress());
				BTArrayAdapter.notifyDataSetChanged();
				
				// Update UI when finding a device, will continue to search, however.
				((ViewGroup)DeviceProgressBar.getParent()).removeView(DeviceProgressBar);
				text.setText("Devices:");
			}
		}
	};
	
	public void searchForDevices() {
		System.out.println("searchForDevices()");
		
		BTArrayAdapter.clear();
		DeviceBluetoothAdapter.startDiscovery();
		
		registerReceiver(bReceiver, new IntentFilter(BluetoothDevice.ACTION_FOUND));	
	}
	
	/*public void off(View view){
	myBluetoothAdapter.disable();
	text.setText("Status: Disconnected");
	
		Toast.makeText(getApplicationContext(),"Bluetooth turned off",
	 		Toast.LENGTH_LONG).show();
	}*/
	
	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		super.onPause();
		
		if( DeviceBluetoothAdapter != null )
			DeviceBluetoothAdapter.startDiscovery();
		
		// Don't keep
		finish();
	}
	
	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		unregisterReceiver(bReceiver);
	}
	
}
