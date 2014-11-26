package com.medicalcyborgs.seniorproject2014;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class ActivitySplash extends Activity {
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.splash);
		
		// Delay for splash screen
		Thread timer = new Thread() {
			public void run() {
				try {
					sleep(1000);
				} catch( InterruptedException e) {
					e.printStackTrace();
				} finally {
					Intent startHome = new Intent("com.medicalcyborgs.seniorproject2014.HOME");
					startActivity(startHome);
				}
			}
		};
		timer.start();
	}
	
	@Override
	protected void onPause() {
		super.onPause();
		
		// Close Splash screen
		finish();
	}
}
