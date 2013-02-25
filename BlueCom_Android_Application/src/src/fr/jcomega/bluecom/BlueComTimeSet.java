/*
 * Copyright (C) 2009 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package fr.jcomega.bluecom;

import java.util.Calendar;
import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.ToggleButton;
import android.app.TimePickerDialog;

/**
 * This Activity appears as a dialog. It lists any paired devices and
 * devices detected in the area after discovery. When a device is chosen
 * by the user, the MAC address of the device is sent back to the parent
 * Activity in the result Intent.
 */
public class BlueComTimeSet extends Activity {
	// Return Intent extra
    public static String EXTRA_ALARM_STATE = "alarm_state";
    
    public static String EXTRA_ALARM_TIME_START = "alarm_time_start";  
    public static String EXTRA_ALARM_HOUR_START="alarm_hour_start";
    public static String EXTRA_ALARM_MINUTE_START="alarm_minute_start";
    
    public static String EXTRA_ALARM_TIME_STOP = "alarm_time_stop";  
    public static String EXTRA_ALARM_HOUR_STOP="alarm_hour_stop";
    public static String EXTRA_ALARM_MINUTE_STOP="alarm_minute_stop";
    
    static final int ALARM_START_DIALOG_ID = 999;
    static final int ALARM_STOP_DIALOG_ID = 888;

    //variable
	private int hour_start;
	private int minute_start;
	private int hour_stop;
	private int minute_stop;
	private int state=1;	

	//graphique interface
	//private TimePicker timePicker_Start;
	//private TimePicker timePicker_Stop;
	private Button TimeSetButton;
	private Button AlarmStartButton;
	private Button AlarmStopButton;
	private ToggleButton ToogleButtonStatus;
	private TextView Title_Actif_Time;
	
    @Override
    protected void onCreate(Bundle savedInstanceState){
    	super.onCreate(savedInstanceState);

        setContentView(R.layout.time_setting);
        // Set result CANCELED incase the user backs out
        setResult(Activity.RESULT_CANCELED); 
        
        //get current time
  
		final Calendar c = Calendar.getInstance();
		hour_start = c.get(Calendar.HOUR_OF_DAY);
		minute_start = c.get(Calendar.MINUTE);
		hour_stop = c.get(Calendar.HOUR_OF_DAY);
		minute_stop = c.get(Calendar.MINUTE)+2;
		
		if (minute_stop > 59)
			{
			minute_stop -= 60;
			hour_stop +=1;
			}

		
		Title_Actif_Time = (TextView) findViewById(R.id.textView_active_time);
		Title_Actif_Time.setText(R.string.title_alarm_out);
		
		AlarmStartButton = (Button) findViewById(R.id.button_Alarm_Start);
		AlarmStartButton.setOnClickListener(new View.OnClickListener(){
        	public void onClick(View v){
        		showDialog(ALARM_START_DIALOG_ID);
      		
        	}
        });
		AlarmStopButton = (Button) findViewById(R.id.button_Alarm_Stop);
		AlarmStopButton.setOnClickListener(new View.OnClickListener(){
        	public void onClick(View v){
        		showDialog(ALARM_STOP_DIALOG_ID);
      		
        	}
        });	
		
		AlarmStartButton.setText(new StringBuilder().append(pad(hour_start))
				.append(":").append(pad(minute_start)));
		AlarmStopButton.setText(new StringBuilder().append(pad(hour_stop))
				.append(":").append(pad(minute_stop)));
			

        // Initialize the button to perform the clock return
        TimeSetButton = (Button) findViewById(R.id.button_Time_Set);
        TimeSetButton.setOnClickListener(new View.OnClickListener(){
        	public void onClick(View v){
        		
        		String Clock_return_start = pad(hour_start)+":"+pad(minute_start);
        		String Clock_return_stop = pad(hour_stop)+":"+pad(minute_stop);       		
                // Create the result Intent and include data return
                Intent intent = new Intent();
                
                intent.putExtra(EXTRA_ALARM_TIME_START, Clock_return_start);
                intent.putExtra(EXTRA_ALARM_TIME_STOP, Clock_return_stop);            
                intent.putExtra(EXTRA_ALARM_HOUR_STOP, hour_stop);
                intent.putExtra(EXTRA_ALARM_MINUTE_STOP, minute_stop);           
                
                intent.putExtra(EXTRA_ALARM_HOUR_START, hour_start);
                intent.putExtra(EXTRA_ALARM_MINUTE_START, minute_start);
                intent.putExtra(EXTRA_ALARM_STATE, state);              
                // Set result and finish this Activity
                setResult(Activity.RESULT_OK, intent);
                finish();        		
        	}
        });
        
        // Initialize the button to perform the output status
        ToogleButtonStatus = (ToggleButton) findViewById(R.id.toggle_Time_Status);
        ToogleButtonStatus.setChecked(true); // for the first time, on
        ToogleButtonStatus.setOnClickListener(new View.OnClickListener(){
        	public void onClick(View v){
                if (ToogleButtonStatus.isChecked())
                {
                	state = 1; //output will be disabled
                }
                else
                {
                	state = 0;	//output will be disabled
                }	
        	}
        });       
  
    }

	@Override
	protected Dialog onCreateDialog(int id) {
		switch (id) {
		case ALARM_START_DIALOG_ID:
			// set time picker as current time
			return new TimePickerDialog(this, timePickerListener_start, hour_start, minute_start,
					true);

		case ALARM_STOP_DIALOG_ID:
			// set time picker as current time
			return new TimePickerDialog(this, timePickerListener_stop, hour_stop, minute_stop,
					true);

		}
		return null;
	}

	private TimePickerDialog.OnTimeSetListener timePickerListener_start = new TimePickerDialog.OnTimeSetListener() {
		public void onTimeSet(TimePicker view, int selectedHour,
				int selectedMinute) {
			hour_start = selectedHour;
			minute_start = selectedMinute;
			
			AlarmStartButton.setText(new StringBuilder().append(pad(hour_start))
					.append(":").append(pad(minute_start)));
		}
	};
	
	private TimePickerDialog.OnTimeSetListener timePickerListener_stop = new TimePickerDialog.OnTimeSetListener() {
		public void onTimeSet(TimePicker view, int selectedHour,
				int selectedMinute) {
			hour_stop = selectedHour;
			minute_stop = selectedMinute;
			
			AlarmStopButton.setText(new StringBuilder().append(pad(hour_stop))
					.append(":").append(pad(minute_stop)));
		}
	};
	
	private static String pad(int c) {
		if (c >= 10)
			return String.valueOf(c);
		else
			return "0" + String.valueOf(c);
	}
}
