package com.medicalcyborgs.seniorproject2014;

//-----------------------------------------------------------------------------
//Purpose: Scribe class for the FitBit API
//-----------------------------------------------------------------------------
import org.scribe.builder.api.DefaultApi10a;
import org.scribe.model.Token;

public class ScribeJawboneAPI extends DefaultApi10a {
	private static final String AUTHORIZE_URL = "https://www.fitbit.com/oauth/authorize?oauth_token=%s";

	@Override
	public String getAccessTokenEndpoint() {
		return "https://jawbone.com/auth/oauth2/token";
	}

	@Override
	public String getRequestTokenEndpoint() {
		return "https://api.fitbit.com/oauth/request_token";
	}

	@Override
	public String getAuthorizationUrl(Token requestToken) {
		return String.format(AUTHORIZE_URL, requestToken.getToken());
	}
}