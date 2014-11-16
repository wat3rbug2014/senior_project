package com.medicalcyborgs.seniorproject2014;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;

import org.scribe.builder.ServiceBuilder;
import org.scribe.builder.api.TwitterApi;
import org.scribe.model.OAuthRequest;
import org.scribe.model.SignatureType;
import org.scribe.model.Token;
import org.scribe.model.Verb;
import org.scribe.model.Verifier;
import org.scribe.oauth.OAuthService;

import com.fitbit.api.client.service.FitbitAPIClientService;

import android.support.v7.app.ActionBarActivity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;

public class ActivityHome extends ActionBarActivity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_home);
		
		// ref xml items
		Button button_devices = (Button)findViewById(R.id.Button_Devices);
		button_devices.setOnClickListener( new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent loadDeviceMenu = new Intent("com.medicalcyborgs.seniorproject2014.DEVICES");
				startActivity(loadDeviceMenu);
				//overridePendingTransition(R.anim.abc_slide_in_top, R.anim.abc_slide_out_top);
			}
		});
		
		Button button_fitbitweb = (Button)findViewById(R.id.Button03);
		button_fitbitweb.setOnClickListener( new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				Intent intnet = new Intent("com.medicalcyborgs.seniorproject2014.FITBITAUTH");
				startActivity(intnet);
			}
		});
	}
	
	
	
	
	
	
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}
}
