package com.medicalcyborgs.seniorproject2014;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class ActivityFitBitWeb extends Activity {

	private String m_sAuthURL;
	WebView m_WebView;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_fitbit);

		m_WebView = (WebView) findViewById(R.id.webview1);
		
		// Catch callback n' stuff
		WebViewClient FitBitWebViewClient = new WebViewClient()
		{
			@Override
			public boolean shouldOverrideUrlLoading(WebView  view, String  url)
			{
				m_sAuthURL = url;
				
				// Check for FitBit Callback
				if( url.contains("fitbit") ) {
					// Now we have the
					//OAuth_FitBit.enterAuthCode("", url);
				}
				
				return super.shouldOverrideUrlLoading(view, url);
			}
		};
		
		m_WebView.setWebViewClient(FitBitWebViewClient);
		
		// Start Authorization
		OAuthFitBit.webRequestAuth(m_WebView);
	}
}
