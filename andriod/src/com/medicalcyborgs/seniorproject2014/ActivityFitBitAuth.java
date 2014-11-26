package com.medicalcyborgs.seniorproject2014;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

public class ActivityFitBitAuth extends Activity {

	private Button m_Button_FitBitWeb;
	private Button m_Button_Auth;
	private EditText m_TextEntry_AuthCode;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.fitbitauth);
		
		m_Button_FitBitWeb = (Button)findViewById(R.id.Button_AuthFitBit);
		m_Button_FitBitWeb.setOnClickListener( new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				// Opens fitbit authorization page
				Intent intnet = new Intent("com.medicalcyborgs.seniorproject2014.FITBITWEB");
				startActivity(intnet);
			}
		});
		
		m_Button_Auth = (Button)findViewById(R.id.Button_Authorize);
		m_Button_Auth.setOnClickListener( new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// Submit Code
				OAuthFitBit.submitAuthCode(m_TextEntry_AuthCode.getText().toString() );
			}
		});
		m_TextEntry_AuthCode = (EditText)findViewById(R.id.TextEntry_AuthCode);
	}
}
