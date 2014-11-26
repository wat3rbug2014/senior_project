package com.medicalcyborgs.seniorproject2014;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

public class FragAdapterAccounts extends FragmentPagerAdapter {
	Fragment m_InfoTab1 = new FragAcctFitBitUserInfo( );
	Fragment m_InfoTab2 = new FragAcctFitBitUserActivityInfo();
	
	public FragAdapterAccounts(FragmentManager fm) {
		super(fm);
		// TODO Auto-generated constructor stub
	}
	
	@Override
	public Fragment getItem(int arg0) {
		switch(arg0) {
		case 0:
			return m_InfoTab1;
		case 1:
			return m_InfoTab2;
		}
		return null;
	}

	@Override
	public int getCount() {
		return 2; // HARDCODED
	}
}