package com.medicalcyborgs.seniorproject2014;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

public class FragAdapterHome extends FragmentPagerAdapter {
	Fragment m_Tab1 = new Tab1();
	Fragment m_Tab2 = new FragDevices();
	Fragment m_Tab3 = new FragInfo();
	
	public FragAdapterHome(FragmentManager fm) {
		super(fm);
		// TODO Auto-generated constructor stub
	}
	
	@Override
	public Fragment getItem(int arg0) {
		// TODO Auto-generated method stub
		switch(arg0) {
		case 0:
			return m_Tab1;
		case 1:
			return m_Tab2;
		case 2:
			return m_Tab3;
		}
		return null;
	}
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return 3; // HARDCODED
	}

}
