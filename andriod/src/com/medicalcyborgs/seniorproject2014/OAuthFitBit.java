package com.medicalcyborgs.seniorproject2014;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.scribe.builder.ServiceBuilder;
import org.scribe.model.OAuthRequest;
import org.scribe.model.Token;
import org.scribe.model.Verb;
import org.scribe.model.Verifier;
import org.scribe.oauth.OAuthService;

import android.content.Context;
import android.os.AsyncTask;
import android.webkit.WebView;

//-----------------------------------------------------------------------------
//Purpose: OAuthication for FitBit Devices.
//-----------------------------------------------------------------------------
final public class OAuthFitBit {
	
	private static OAuthService FitBitOAuthService = null;
	private static Token m_tRequestToken;
	private static Token m_tAccessToken; // Used FitBit Resource API Calls after OAuth.
	protected static String m_sAuthURL;
	private static boolean m_bIsAuthed;
	
	public static final String m_sFitBitFileName = "fitbitaccesscode";

	public static String m_sfitbitUserData = null;
	public static String m_sfitbitUserActivityData = null;
	
	public static Context context;
	
	public static void webRequestAuth(final WebView webView) {
		//if( m_bIsAuthed )
		//	return;
		
		setupFitBitService();
		
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
		//if( m_bIsAuthed )
		//	return;
		
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
						asyncGetUserData_FitBit();
						saveAuthToken();
						m_bIsAuthed = true;
						return null; // ?
					}
				}).execute();
			}
		}).execute();
	}
	
	private static void setupFitBitService() {
		if( FitBitOAuthService != null ) {
			return;
		}
		
		FitBitOAuthService = new ServiceBuilder()
		.provider(ScribeFitBitAPI.class)
		.apiKey("ac11137f4ae14808803eceb2f3deb696") // These are taken from your AppID on the FitBit dev website
		.apiSecret("0cd666b4e26047119509def13c38c175") // These are taken from your AppID on the FitBit dev website
		//.callback("https://fitbit.com/oauth/callback")
		.build();
	}
	
	private static void saveAuthToken() {
		// SAVE AccessToken (Hacky and insecure!)
		ObjectOutputStream  oos = null;
		FileOutputStream fos;
		try {
			fos = context.openFileOutput(m_sFitBitFileName, Context.MODE_PRIVATE);
			oos = new ObjectOutputStream( new ObjectOutputStream(fos));
			//System.out.println("Saved Token: " + m_tAccessToken.getToken());
			//System.out.println("Saved Secret: " + m_tAccessToken.getSecret());
			//System.out.println("Saved RawResponse: " + m_tAccessToken.getRawResponse());
			oos.writeObject(m_tAccessToken);
			//bw.write(m_tAccessToken.getToken() + "\n" + m_tAccessToken.getSecret() + "\n" + m_tAccessToken.getRawResponse());
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				oos.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public static void setAccessToken(Token savedAuthToken ) {
		m_tAccessToken = savedAuthToken;
		m_bIsAuthed = true;
	}
	
	public static boolean isAuthed() {
		return m_bIsAuthed;
	}
	
	public static void asyncGetUserData_FitBit() {
		setupFitBitService();
		OAuthRequest request = new OAuthRequest(Verb.GET, "https://api.fitbit.com/1/user/-/profile.json");
		FitBitOAuthService.signRequest(m_tAccessToken, request);
		org.scribe.model.Response response = request.send();
		m_sfitbitUserData = response.getBody();
		//System.out.println(m_sfitbitUserData);
	}
	
	public static void asyncGetActivities(Calendar date) {
		setupFitBitService();
		OAuthRequest request = new OAuthRequest(Verb.GET, "https://api.fitbit.com/1/user/-/activities/date/"+new SimpleDateFormat("yyyy-MM-dd").format(date.getTime())+".json");
		FitBitOAuthService.signRequest(m_tAccessToken, request);
		org.scribe.model.Response response = request.send();
		m_sfitbitUserActivityData = response.getBody();
		System.out.println(response.getBody());
	}
}