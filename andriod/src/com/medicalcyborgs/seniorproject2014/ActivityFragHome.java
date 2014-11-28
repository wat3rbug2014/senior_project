package com.medicalcyborgs.seniorproject2014;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.ObjectInputStream;
import org.scribe.model.Token;

import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.app.ActionBar;
import android.app.ActionBar.Tab;
import android.app.FragmentTransaction;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

public class ActivityFragHome extends FragmentActivity implements ActionBar.TabListener {
	ActionBar m_ActionBar;
	ViewPager m_ViewPager;
	FragmentPagerAdapter m_FPA;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.frag_base);
		
		// HACK, auth stuff
		OAuthFitBit.context = getApplicationContext();
		
		ObjectInputStream ois = null;
		try {
			FileInputStream fis = openFileInput(OAuthFitBit.m_sFitBitFileName);
			ois = new ObjectInputStream(new ObjectInputStream(fis));
			Token savedAuthToken = (Token)ois.readObject();
			System.out.println("Saved Token: " + savedAuthToken.getToken());
			System.out.println("Saved Secret: " + savedAuthToken.getSecret());
			System.out.println("Saved RawResponse: " + savedAuthToken.getRawResponse());
			OAuthFitBit.setAccessToken( savedAuthToken );
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
		} finally {
			try {
				if( ois != null ) {
					ois.close();
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		// Setup Tabs
		m_ViewPager = (ViewPager)findViewById(R.id.pager);
		m_FPA = new FragAdapterHome(getSupportFragmentManager());
		m_ViewPager.setAdapter(m_FPA);
		m_ActionBar = getActionBar();
		m_ActionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
		m_ActionBar.addTab(m_ActionBar.newTab().setText("Home").setTabListener(this));
		m_ActionBar.addTab(m_ActionBar.newTab().setText("Devices").setTabListener(this));
		m_ActionBar.addTab(m_ActionBar.newTab().setText("Info").setTabListener(this));
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
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
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
