package com.medicalcyborgs.seniorproject2014;

import android.os.Bundle;
import android.os.Handler;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ProgressBar;;

public class FragDevices extends Fragment {

	// Elements
	private TextView m_TextView_BTLED;
	private ListView m_ListView_BTLEDevices;
	private ProgressBar m_ProgressBar_BTLED;
	private Button m_Button_Scan;
	
	// BlueTooth LE
	private BluetoothAdapter DeviceBluetoothAdapter;
	//private Set<BluetoothDevice> DeviceList;
	private ArrayAdapter<String> BTArrayAdapter;

	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		
		return inflater.inflate(R.layout.activity_devices, container, false );
	}

	@Override
	public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onViewCreated(view, savedInstanceState);
		//getActivity().setContentView(R.layout.activity_devices);
		
		// Get BlueTooth Adapter
		DeviceBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
		
		// Check if device has supports BlueTooth
		if(DeviceBluetoothAdapter != null) {
			
			// Get Elements
			m_TextView_BTLED = (TextView)getActivity().findViewById(R.id.TextView_BTLED);
			m_ProgressBar_BTLED = (ProgressBar)getActivity().findViewById(R.id.BLEDD_ProgressBar);
		 
			m_ListView_BTLEDevices = (ListView)getActivity().findViewById(R.id.ListView_Simple);
	
			// Device List
			BTArrayAdapter = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_list_item_1);
			m_ListView_BTLEDevices.setAdapter(BTArrayAdapter);
			
		} else {
			m_TextView_BTLED.setText("BlueTooth not supported!");
				
			Toast.makeText(getActivity().getApplicationContext(),"Your device does not support Bluetooth!", Toast.LENGTH_LONG).show();
			m_Button_Scan.setEnabled(false);
		}
	}
	
	@Override
	public void onActivityCreated(@Nullable Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onActivityCreated(savedInstanceState);
		
		m_Button_Scan = (Button)getActivity().findViewById(R.id.Button_Scan);
		m_Button_Scan.setOnClickListener( new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				searchForDevices();
				m_Button_Scan.setEnabled(false);
				m_ProgressBar_BTLED.setVisibility(View.VISIBLE);
				m_TextView_BTLED.setText("Discovering Devices. .");
			}
		});
			
		m_TextView_BTLED.setText("");
	}
	
	final BroadcastReceiver bReceiver = new BroadcastReceiver() {
		 public void onReceive(Context context, Intent intent) {
			String action = intent.getAction();
			
			// Device Found
			if (BluetoothDevice.ACTION_FOUND.equals(action)) {
				BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
				
				System.out.println("Found Device! " + device.getName());
				
				m_ListView_BTLEDevices.setVisibility(View.VISIBLE);
				
				// Add device and MAC address to list
				BTArrayAdapter.add(device.getName() + "\n" + device.getAddress());
				BTArrayAdapter.notifyDataSetChanged();
				
				// Update UI when finding a device, will continue to search, however.
				//((ViewGroup)DeviceProgressBar.getParent()).removeView(DeviceProgressBar);
				m_ProgressBar_BTLED.setVisibility(View.INVISIBLE);
				m_TextView_BTLED.setText("Devices:");
			}
		}
	};
	
	public void searchForDevices() {
		
		if( DeviceBluetoothAdapter.isDiscovering() )
			return;
		
		// TODO: Wait for bluetooth to enable before scanning
		if( !DeviceBluetoothAdapter.isEnabled() ) {
			// Turn on BlueTooth if it's off (Device may prompt user)
			DeviceBluetoothAdapter.enable();
		}
		
		BTArrayAdapter.clear();
		DeviceBluetoothAdapter.startDiscovery();
		
		// Stop discovery after 12 seconds.
		new Handler().postDelayed(new Runnable() {
			@Override
			public void run() {
				DeviceBluetoothAdapter.cancelDiscovery();
				m_ProgressBar_BTLED.setVisibility(View.INVISIBLE);
				m_Button_Scan.setEnabled(true);
			}
		}, 12000);
		
		getActivity().registerReceiver(bReceiver, new IntentFilter(BluetoothDevice.ACTION_FOUND));
	}
}
