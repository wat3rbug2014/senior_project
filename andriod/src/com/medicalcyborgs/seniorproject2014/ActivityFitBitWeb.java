package com.medicalcyborgs.seniorproject2014;

import android.app.Activity;
import android.os.Bundle;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class ActivityFitBitWeb extends Activity {

	WebView m_WebView;
	boolean b = true; // FIXME

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_fitbitwebauth);
		m_WebView = (WebView) findViewById(R.id.webview1);
		
		// Catch callback n' stuff
		WebViewClient FitBitWebViewClient = new WebViewClient() {
			@Override
			public void onPageFinished(WebView view, String url) {
				// TODO Auto-generated method stub
				super.onPageFinished(view, url);
				
				// Remove GUI elements
				if( b )
				{
					((ViewGroup)findViewById(R.id.ProgressBar_FitBitWebAuth).getParent()).removeView(findViewById(R.id.ProgressBar_FitBitWebAuth));
					((ViewGroup)findViewById(R.id.TextView_FitBitWebAuth).getParent()).removeView(findViewById(R.id.TextView_FitBitWebAuth));
					findViewById(R.id.webview1).setVisibility(0); // TODO
					b = false;
				}
			}
			
			@Override
			public boolean shouldOverrideUrlLoading(WebView  view, String  url) {
				return super.shouldOverrideUrlLoading(view, url);
			}
		};
		
		m_WebView.setWebViewClient(FitBitWebViewClient);
		
		// Start Authorization
		OAuthFitBit.webRequestAuth(m_WebView);
	}
}
