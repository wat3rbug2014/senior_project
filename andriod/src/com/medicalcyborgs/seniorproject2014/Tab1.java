package com.medicalcyborgs.seniorproject2014;

import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class Tab1 extends Fragment {
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		
		// Keep instance
		setRetainInstance(true); // no workie?
		return inflater.inflate(R.layout.tab1, container, false );
	}
}