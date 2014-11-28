package com.medicalcyborgs.seniorproject2014;

import android.app.ActionBar;
import android.app.ActionBar.Tab;
import android.app.FragmentTransaction;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;

public class ActivityFragAccts extends FragmentActivity implements ActionBar.TabListener {
	
	ActionBar m_ActionBar;
	ViewPager m_ViewPager;
	public FragmentPagerAdapter m_FPA;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.frag_base);
		
		// Setup Tabs
		m_ViewPager = (ViewPager)findViewById(R.id.pager);
		m_FPA = new FragAdapterAccounts(getSupportFragmentManager());
		m_ViewPager.setAdapter(m_FPA);
		m_ActionBar = getActionBar();
		m_ActionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
		m_ActionBar.addTab(m_ActionBar.newTab().setText("User Info").setTabListener(this));
		m_ActionBar.addTab(m_ActionBar.newTab().setText("Activities").setTabListener(this));
		m_ViewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
			
			@Override
			public void onPageSelected(int arg0) {
				// TODO Auto-generated method stub
				m_ActionBar.setSelectedNavigationItem(arg0);
			}
			
			@Override
			public void onPageScrolled(int arg0, float arg1, int arg2) {
				// TODO Auto-generated method stub
			}
			
			@Override
			public void onPageScrollStateChanged(int arg0) {
				// TODO Auto-generated method stub
			}
		});
	}

	@Override
	public void onTabSelected(Tab tab, FragmentTransaction ft) {
		// TODO Auto-generated method stub
		m_ViewPager.setCurrentItem(tab.getPosition());
	}

	@Override
	public void onTabUnselected(Tab tab, FragmentTransaction ft) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onTabReselected(Tab tab, FragmentTransaction ft) {
		// TODO Auto-generated method stub
		
	}
}
