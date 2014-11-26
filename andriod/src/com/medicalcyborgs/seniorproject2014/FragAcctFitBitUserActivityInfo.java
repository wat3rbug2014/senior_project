package com.medicalcyborgs.seniorproject2014;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

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

public class FragAcctFitBitUserActivityInfo extends Fragment {
	
	private ListView m_lvUserDetails;
	private ArrayAdapter<String> m_aaUserDetails;
	private JSONObject m_JSONUser;
	
	private ArrayList<String> m_alActHistory = new ArrayList<String>();
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		return inflater.inflate(R.layout.frag_info_fitbituseractivity, container, false );
	}
	
	@Override
	public void onActivityCreated(@Nullable Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		
		if( OAuthFitBit.isAuthed() ) // TODO move to proper
		{
			// Make sure we have the userdata
			if(m_alActHistory.isEmpty()) {
				(new AsyncTask<Void, Void, String>() {
					@Override
					protected String doInBackground(Void... params) {
						// Sequentially get the last 5 days
						//m_alActHistory.clear();
						for (int i = 0; i < 5; i++) {
							Calendar date = Calendar.getInstance();
							date.add(Calendar.DAY_OF_MONTH, -i);
							OAuthFitBit.asyncGetActivities(date);
							m_alActHistory.add( i, OAuthFitBit.m_sfitbitUserActivityData);
							//System.out.println(date.toString());
						}
						return null; // ?
					}
					@Override
					protected void onPostExecute(String url) {
						(getActivity().findViewById(R.id.TextView_FitBitActivity)).setVisibility(View.INVISIBLE);
						(getActivity().findViewById(R.id.ProgressBar_FitBitActivity)).setVisibility(View.INVISIBLE);
						displayUserActivityDetails();
					}
				}).execute();
			}
			else {
				displayUserActivityDetails();
			}
		}
	}
	
	private void displayUserActivityDetails() {
		m_lvUserDetails = (ListView)getActivity().findViewById(R.id.ListView_Simple2);
		m_aaUserDetails = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_list_item_1);
		m_lvUserDetails.setAdapter(m_aaUserDetails);
		
		for (int i = 0; i < m_alActHistory.size(); i++) {
			try {
				m_JSONUser = new JSONObject(m_alActHistory.get(i)).getJSONObject("summary");
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			Calendar date = Calendar.getInstance();
			date.add(Calendar.DAY_OF_MONTH, -i);
			
			// Print data
			m_aaUserDetails.add("\t\t" + new SimpleDateFormat("yyyy-MM-dd").format(date.getTime()));
			listDataItem("Steps Taken: ", "steps");
			listDataItem("Sedentary Minutes: ", "sedentaryMinutes");
			listDataItem("Lightly Active Minutes: ", "lightlyActiveMinutes");
			listDataItem("Fairly Active Minutes: ", "fairlyActiveMinutes");
			listDataItem("Very Active Minutes: ", "veryActiveMinutes");
		}
		m_aaUserDetails.notifyDataSetChanged();
	}
	
	/**
	 * List a data item in the ListView
	 * @param desc prefix (description) for the item.
	 * @param item string to look for in json data.
	 */
	private void listDataItem(String desc, String item) {
		try {
			m_aaUserDetails.add(desc + m_JSONUser.getString(item));
		} catch (JSONException e) {
			System.out.printf("Failed to get data for item '%s'\n", item);
		}
	}
}

