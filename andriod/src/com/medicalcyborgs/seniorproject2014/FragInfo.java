package com.medicalcyborgs.seniorproject2014;

import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

public class FragInfo extends Fragment {
	
	Button m_Button_FitBit;
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		return inflater.inflate(R.layout.frag_info, container, false );
	}
	
	@Override
	public void onActivityCreated(@Nullable Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		
		m_Button_FitBit = (Button)getActivity().findViewById(R.id.Button_FitBit_Auth_or_Info);
		((Button)getActivity().findViewById(R.id.Button_Jawbone_Auth_or_Info)).setEnabled(false);
		
		// Check if we're already authed TODO jawbone
		if( OAuthFitBit.isAuthed() )
		{
			// We're already authed so change this to take us to the FitBit data page
			m_Button_FitBit.setText("FitBit (Synced)");
			
			//
			m_Button_FitBit.setOnClickListener( new View.OnClickListener() {
				
				@Override
				public void onClick(View v) {
					Intent intent = new Intent("com.medicalcyborgs.seniorproject2014.FITBITDATA");
					startActivity(intent);
				}
			});
		}
		else {
		m_Button_FitBit.setOnClickListener( new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent intent = new Intent("com.medicalcyborgs.seniorproject2014.FITBITAUTH");
				startActivity(intent);
			}
		});
		}
	}
}
