package com.medicalcyborgs.seniorproject2014;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.scribe.builder.ServiceBuilder;
import org.scribe.model.OAuthRequest;
import org.scribe.model.Token;
import org.scribe.model.Verb;
import org.scribe.model.Verifier;
import org.scribe.oauth.OAuthService;
import android.os.AsyncTask;
import android.text.format.DateFormat;
import android.webkit.WebView;

//-----------------------------------------------------------------------------
//Purpose: OAuthication for FitBit Devices.
//-----------------------------------------------------------------------------
final public class OAuthFitBit {
	
	private static OAuthService FitBitOAuthService;
	private static Token m_tRequestToken;
	private static Token m_tAccessToken; // Used FitBit Resource API Calls after OAuth.
	protected static String m_sAuthURL;
	private static boolean m_bIsAuthed;
	
	public static void webRequestAuth(final WebView webView) {
		if( m_bIsAuthed )
			return;
		
		FitBitOAuthService = new ServiceBuilder()
		.provider(ScribeFitBitAPI.class)
		.apiKey("ac11137f4ae14808803eceb2f3deb696") // These are taken from your AppID on FitBit.com
		.apiSecret("0cd666b4e26047119509def13c38c175") // These are taken from your AppID on FitBit.com
		//.callback("https://fitbit.com/oauth/callback") // NOTE: Dummy callback
		.build();
		
		// Get Request Token
		(new AsyncTask<Void, Void, String>() {
			@Override
			protected String doInBackground(Void... params) {
				m_tRequestToken = FitBitOAuthService.getRequestToken();
				return null; // ?
			}
			
			@Override
			protected void onPostExecute(String url) {
				m_sAuthURL = FitBitOAuthService.getAuthorizationUrl(m_tRequestToken);
				
				// Now that we have the token, load auth page
				webView.loadUrl(m_sAuthURL);
			}
		}).execute();
	}
	
	public static void submitAuthCode(final String authcode) {
		if( m_bIsAuthed )
			return;
		
		// Start Authorization
		(new AsyncTask<Void, Void, String>() {
			@Override
			protected String doInBackground(Void... params) {
				m_tAccessToken = FitBitOAuthService.getAccessToken(m_tRequestToken, new Verifier(authcode));
				return null; // ?
			}
			
			@Override
			protected void onPostExecute(String url) {
				(new AsyncTask<Void, Void, String>() {
					@Override
					protected String doInBackground(Void... params) {
						OAuthRequest request = new OAuthRequest(Verb.GET, "https://api.fitbit.com/1/user/-/profile.json");
						FitBitOAuthService.signRequest(m_tAccessToken, request);
						org.scribe.model.Response response = request.send();
						String debugresponce = response.getBody();
						System.out.println(response.getBody());
						return null; // ?
					}
				}).execute();
			}
		}).execute();
	}
	
	public static boolean isAuthed() {
		return m_bIsAuthed;
	}
	
	public static void asyncGetActivities(String activities) {
		// TODO: handle dates
		OAuthRequest request = new OAuthRequest(Verb.GET, "https://api.fitbit.com/1/user/-/activities/date/"+new SimpleDateFormat("yyyy-MM-dd").format(new Date())+".json");
		FitBitOAuthService.signRequest(m_tAccessToken, request);
		org.scribe.model.Response response = request.send();
		activities = response.getBody();
		System.out.println(response.getBody());
	}
}
