package com.medicalcyborgs.seniorproject2014;

import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import org.json.JSONException;
import org.json.JSONObject;

import android.os.AsyncTask;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class FragAcctFitBitUserInfo extends Fragment {
	
	private ListView m_lvUserDetails;
	private ArrayAdapter<String> m_aaUserDetails;
	private JSONObject m_JSONUser;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		return inflater.inflate(R.layout.frag_info_fitbituserdata, container, false );
	}
	
	@Override
	public void onActivityCreated(@Nullable Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		
		if( OAuthFitBit.isAuthed() ) // TODO move to proper
		{
			// Make sure we have the userdata
			if(OAuthFitBit.m_sfitbitUserData == null) {
				(new AsyncTask<Void, Void, String>() {
					@Override
					protected String doInBackground(Void... params) {
						OAuthFitBit.asyncGetUserData_FitBit();
						return null; // ?
					}
					@Override
					protected void onPostExecute(String url) {
						(getActivity().findViewById(R.id.TextView_FitBitUserData)).setVisibility(View.INVISIBLE);
						(getActivity().findViewById(R.id.ProgressBar_FitBitUserData)).setVisibility(View.INVISIBLE);
						displayUserDetails();
					}
				}).execute();
			}
			else {
				(getActivity().findViewById(R.id.TextView_FitBitUserData)).setVisibility(View.INVISIBLE);
				(getActivity().findViewById(R.id.ProgressBar_FitBitUserData)).setVisibility(View.INVISIBLE);
				displayUserDetails();
			}
		}
	}
	
	private void displayUserDetails() {
		m_lvUserDetails = (ListView)getActivity().findViewById(R.id.ListView_Simple);
		
		m_aaUserDetails = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_list_item_1);
		m_lvUserDetails.setAdapter(m_aaUserDetails);
		
		try {
			m_JSONUser = new JSONObject(OAuthFitBit.m_sfitbitUserData).getJSONObject("user");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// NOTE: null vals are skipped
		try {
			m_aaUserDetails.add("Name: " + m_JSONUser.getString("fullName"));
			m_aaUserDetails.add("NickName: " + m_JSONUser.getString("nickname"));
			m_aaUserDetails.add("Gender: " + m_JSONUser.getString("gender"));
			m_aaUserDetails.add("DOB: " + m_JSONUser.getString("dateOfBirth"));
			m_aaUserDetails.add("Height: " + m_JSONUser.getString("height"));
			m_aaUserDetails.add("Weight: " + m_JSONUser.getString("weight"));
			m_aaUserDetails.add("City: " + m_JSONUser.getString("city"));
			m_aaUserDetails.add("Country: " + m_JSONUser.getString("country"));
			m_aaUserDetails.add("Join Date: " + m_JSONUser.getString("memberSince"));
			m_aaUserDetails.add("About: " + m_JSONUser.getString("about"));
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
		}
		m_aaUserDetails.notifyDataSetChanged();
	}
}

