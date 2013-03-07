/***************************************
 * 
 * Android BlueCom Remote Control
 * jC_Omega  Jean-Christophe PAPELARD
 * Juillet 2012
 *  
 ***************************************/

package fr.jcomega.bluecom;


import fr.jcomega.bluecom.R;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.PowerManager;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnTouchListener;
import android.view.Window;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Calendar;
import android.app.AlertDialog;
import android.content.DialogInterface;
import java.util.List;
import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

public class BlueComActivity extends Activity implements ColorPickerDialog.OnColorChangedListener {
	
	// Message types sent from the BluetoothRfcommClient Handler
    public static final int MESSAGE_STATE_CHANGE = 1;
    public static final int MESSAGE_READ = 2;
    public static final int MESSAGE_WRITE = 3;
    public static final int MESSAGE_DEVICE_NAME = 4;
    public static final int MESSAGE_TOAST = 5;
    
	// Key names received from the BluetoothRfcommClient Handler
    public static final String DEVICE_NAME = "device_name";
    public static final String TOAST = "toast";
    
    // Intent request codes
    private static final int REQUEST_CONNECT_DEVICE = 1;
    private static final int REQUEST_ENABLE_BT = 2;
    private static final int REQUEST_TIME_SETTING = 3;   
    
    // Communication define
    // Bluecom length for transmit and receive  (#define in C )
    public static final int BLUECOM_RX_TRAME_LENGTH = 13;
    public static final int BLUECOM_TX_TRAME_LENGTH = 13;
    public static final int BLUECOM_TIME_MS_TIMER_TASK = 200;  
    
 // Bluetooth command with uart
    public static final int CMD_DONOTHING = 				0x00;
    public static final int CMD_STATUS_SYSTEMS =			0x01;		//

    public static final int CMD_SET_CURRENT_TIME = 			0x10;		//
    public static final int CMD_READ_CURRENT_TIME =			0x11;		//
    public static final int CMD_SET_ALARM_TIME = 			0x12;		//
    public static final int CMD_READ_ALARM_TIME =			0x13;		//
    public static final int CMD_SET_ALARM_DAY_TIME = 		0x14;		//
    public static final int CMD_READ_ALARM_DAY_TIME =		0x15;		//

    public static final int CMD_SET_DIGITAL_OUTPUT = 		0x20;		//set output
    public static final int CMD_READ_DIGITAL_INPUT =		0x21;		//read input
    public static final int CMD_SET_PWM  = 					0x22;		//set PWM
    public static final int CMD_SET_ANALOG_OUTPUT =			0x23;
    public static final int CMD_READ_ANALOG_INPUT = 		0x24;
    public static final int CMD_SET_RGB_OUTPUT  = 			0x25;		//set LED RGB OUTPUT
    
	//////////////////////////////////////////////////////
	//VARIABLE OUTPUT 1
	// Button output 1
	private ImageButton imageButton_OnOff_out0;
    private Button mAlarmSettingButton_out0;
	private Button mAlarmButtonONOFF_out0;
    TextView title_alarm_start_out0 = null;  
    TextView title_alarm_stop_out0 = null;  
    TextView title_alarm_status_out0 = null;  
	// Variable for blueCom application
	private boolean Flag_imageButton_OnOff_out0 = false;
	private boolean Flag_alarmONOFF_0 = false;
    
	//////////////////////////////////////////////////////
	//VARIABLE OUTPUT RGB
	// Button output rgb
	private ImageButton imageButton_OnOff_rgb;
	private ImageButton imageButton_RGB_rgb;
    private Button mAlarmSettingButton_rgb;
	private Button mAlarmButtonONOFF_rgb;
    TextView title_alarm_start_rgb = null;  
    TextView title_alarm_stop_rgb = null;  
    TextView title_alarm_status_rgb = null; 
	// Variable for blueCom application
	private boolean Flag_imageButton_OnOff_rgb = false;
	private boolean Flag_alarmONOFF_rgb = false;
	
	// global variable for RGB LED projector
	private	int RGB_LED_Alpha = 255;
	private	int RGB_LED_Color = 0xFFFF0000; //red
	
	
	//////////////////////////////////////////////////////
	// GENERAL VARIABLE
	// Button general
    private Button mConnectButton;
    private Button mExitButton;
    private Button mAboutButton;
    TextView title_status = null;
    // Image logo bluetooth
	private ImageView img_bluetooth;
	private boolean Flag_TimerTask_BC_Transmit = false;	
	// adresse MAC puce bluetooth 
	private String address;
	
	//VARIABLES FOR TRANSMITION + RECEPTION TRAME	
	//Bluetooth_structure_trame BlueCom_Trame_Transmit = new Bluetooth_structure_trame();
	Bluetooth_structure_trame BlueCom_Trame_Receive = new Bluetooth_structure_trame();
	
	
	// ENUM VARIABLES FOR DATA STRUCTURE
	
	enum BLUECOM_Type
	{
	BC_TYPE_1RELAYS,
	BC_TYPE_4RELAYS,
	BC_ERROR,
	BC_DEFAUT
	};

	enum BLUECOM_Status
	{
	BC_STATUS_OK ,
	BC_STATUS_FAIL,
	BC_STATUS_DEGRADED,
	BC_STATUS_OTHER,
	BC_STATUS_NOCONNECTED,
	BC_STATUS_DEFAULT
	};
	
	private class Bluetooth_structure_receive
	{
		
		BLUECOM_Type BlueCom_Type ; //bluecom board type
		byte Soft_Revision;
		BLUECOM_Status Board_Status;
		byte Input_Status;
		byte Output_Status;
		
		public Bluetooth_structure_receive(){
		// main variable
			BlueCom_Type = BLUECOM_Type.BC_DEFAUT;
			Soft_Revision=0x00;
			Board_Status = BLUECOM_Status.BC_STATUS_DEFAULT;
			Input_Status = 0x00;
			Input_Status=0x00;
			Output_Status=0x00;
		}
	}
	
	Bluetooth_structure_receive BlueCom_Structure_Receive = new Bluetooth_structure_receive();
	
	// END OF ENUM VARIABLES FOR DATA STRUCTURE

	// declare fifo object for the bluecom transmition
	Fifo TransmitFifo = new Fifo();
	
    //Declare the timer
    Timer MyTimer = new Timer();
		
    // Name of the connected device
    private String mConnectedDeviceName = null;
    // Local Bluetooth adapter
    private BluetoothAdapter mBluetoothAdapter = null;
    // Member object for the RFCOMM services
    private BluetoothRfcommClient mRfcommClient = null; 
    // stay awake
    protected PowerManager.WakeLock mWakeLock; 
    
    // END OF VARIABLES CREATION
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Set up the window layout
        requestWindowFeature(Window.FEATURE_NO_TITLE);        
        setContentView(R.layout.main);
        
        // Get local Bluetooth adapter
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        
        // If the adapter is null, then Bluetooth is not supported
        if (mBluetoothAdapter == null) {
            Toast.makeText(this, "Bluetooth is not available", Toast.LENGTH_LONG).show();
            finish();
            return;
        }
        /*
        // Prevent phone from sleeping
        PowerManager pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
        this.mWakeLock = pm.newWakeLock(PowerManager.FULL_WAKE_LOCK, "My Tag"); 
        this.mWakeLock.acquire();
		*/
        
    }
    
    @Override
    public void onStart(){
    	super.onStart();	
    	// If BT is not on, request that it be enabled.
    	if (!mBluetoothAdapter.isEnabled()){
    		Intent enableIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
    		startActivityForResult(enableIntent, REQUEST_ENABLE_BT);
    	}
    	// Otherwise, setup the IHM session
    	else{
    		if (mRfcommClient == null)
    			{
    				setupIHM();
    			}
    	}    	
    }
    
    @Override
    public synchronized void onResume(){
    	super.onResume();
    	// Performing this check in onResume() covers the case in which BT was
        // not enabled during onStart(), so we were paused to enable it...
        // onResume() will be called when ACTION_REQUEST_ENABLE activity returns.
        if (mRfcommClient != null) {
            // Only if the state is STATE_NONE, do we know that we haven't started already
            if (mRfcommClient.getState() == BluetoothRfcommClient.STATE_NONE) {
              // Start the Bluetooth  RFCOMM services
              mRfcommClient.start();
            }
        }
    }
     

    @Override
    public void onDestroy(){
    	super.onDestroy();
    	// Stop the Bluetooth RFCOMM services
        if (mRfcommClient != null) mRfcommClient.stop();
        // release screen being on
        //if (mWakeLock.isHeld()) { 
        //    mWakeLock.release();
        //}
    }
    
    private void setupIHM(){       
        // button/textview output1
        imageButton_OnOff_out0 = (ImageButton)findViewById(R.id.imageButton_OnOff_out0);
        title_alarm_start_out0 = (TextView)findViewById(R.id.title_Alarm_start_out0); 
        title_alarm_stop_out0 = (TextView)findViewById(R.id.title_Alarm_stop_out0); 
        title_alarm_status_out0 = (TextView)findViewById(R.id.title_Alarm_status_out0); 
        mAlarmSettingButton_out0 = (Button) findViewById(R.id.button_alarm_set_out0); 
        mAlarmButtonONOFF_out0 = (Button) findViewById(R.id.Button_alarmONOFF_out0);
        
        // button/textview output rgb  
        imageButton_OnOff_rgb = (ImageButton)findViewById(R.id.imageButton_OnOff_rgb);
        imageButton_RGB_rgb = (ImageButton)findViewById(R.id.imageButton_RGB_rgb);
        title_alarm_start_rgb = (TextView)findViewById(R.id.title_Alarm_start_rgb); 
        title_alarm_stop_rgb = (TextView)findViewById(R.id.title_Alarm_stop_rgb); 
        title_alarm_status_rgb = (TextView)findViewById(R.id.title_Alarm_status_rgb); 
        mAlarmSettingButton_rgb = (Button) findViewById(R.id.button_alarm_set_rgb); 
        mAlarmButtonONOFF_rgb = (Button) findViewById(R.id.Button_alarmONOFF_rgb);
        
        // button/textview genral
        mConnectButton = (Button) findViewById(R.id.button_connect);
        mExitButton = (Button) findViewById(R.id.button_exit);
        mAboutButton =  (Button) findViewById(R.id.button_about);
        title_status = (TextView)findViewById(R.id.title_status); 
        img_bluetooth = (ImageView)findViewById(R.id.imageView_bluetooth);  
      
        
        /////////////////////////////////////   GENERAL  LISTENER	//////////////////////////
        
        mExitButton.setOnClickListener( new View.OnClickListener() {  
       	   @Override
       	   public void onClick(View v) {   
       		   onDestroy();
       		   finish();
       		   System.runFinalizersOnExit(true);
       		   System.exit(0);
       	   }
       	  });
        
        mAboutButton.setOnClickListener( new View.OnClickListener() {  
        	   @Override
        	   public void onClick(View v) {   
        		   BTDialog();
        	   }
        	  });
        
        mConnectButton.setOnClickListener(new View.OnClickListener() {
			public void onClick(View arg0) {
				//BTConnect();
		    	if (getConnectionState() == BluetoothRfcommClient.STATE_NONE) {
		    		// Launch the DeviceListActivity to see devices and do scan
		    		Log.w("BlueCom","BT Starting...");
		    		BTConnect();
		    	}
		    	else
		        	if (getConnectionState() == BluetoothRfcommClient.STATE_CONNECTED) {
		        		Log.w("BlueCom","BT stop"); 
		        		mRfcommClient.stop();
		        		mRfcommClient.start();
		        	}
			}
		});

        /////////////////////////////////////   OUTPUT 0  LISTENER	//////////////////////////
        // Bouton 0 for output 0
        imageButton_OnOff_out0.setOnTouchListener(new OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {

         		if(event.getAction() == MotionEvent.ACTION_DOWN) {
         			if (Flag_imageButton_OnOff_out0 == true) {				

          		       Log.i("BlueCom", "ACTION : Bouton 0 detect true");
          		       //Transmit : output 0 must be OFF
          		       Bluetooth_structure_trame BlueCom_Trame_Transmit_Button01 = new Bluetooth_structure_trame(CMD_SET_DIGITAL_OUTPUT,0,-1,-1,-1,-1,-1,-1,-1);   				
          		       TransmitFifo.put(BlueCom_Trame_Transmit_Button01); 
          		       if (Flag_TimerTask_BC_Transmit == false) MyTimer.scheduleAtFixedRate(new TransmitTask(), 0, BLUECOM_TIME_MS_TIMER_TASK); // start timer task if the previous timer task is not running

         			}
         			else if (Flag_imageButton_OnOff_out0 == false) {
 
         		       Log.i("BlueCom", "ACTION : Bouton 0 detect false");
         		       //Transmit : output 0 must be OFF
          		       Bluetooth_structure_trame BlueCom_Trame_Transmit_Button01 = new Bluetooth_structure_trame(CMD_SET_DIGITAL_OUTPUT,1,-1,-1,-1,-1,-1,-1,-1);   				
          		       TransmitFifo.put(BlueCom_Trame_Transmit_Button01); 
          		       if (Flag_TimerTask_BC_Transmit == false) MyTimer.scheduleAtFixedRate(new TransmitTask(), 0, BLUECOM_TIME_MS_TIMER_TASK); // start timer task if the previous timer task is not running

         			}        			
                } else if (event.getAction() == MotionEvent.ACTION_UP) {
                	//imageButton_OnOff_out0.setImageResource(R.drawable.power_off_button);
                	
                }
                return true;
            }
        });
        
        mAlarmSettingButton_out0.setOnClickListener( new View.OnClickListener() {  
        	   @Override
        	   public void onClick(View arg0) {   
        		   //launch alarm setting
        		   Intent TimeIntent = new Intent(BlueComActivity.this, BlueComTimeSet.class);
        		   TimeIntent.putExtra("Output Select",0);	//output 0
        	    	startActivityForResult(TimeIntent, REQUEST_TIME_SETTING);   		   
        	   }
        	  });
        
        // Initialize the button to perform the output status
        mAlarmButtonONOFF_out0.setOnClickListener(new View.OnClickListener(){
        	public void onClick(View arg0){
                if (Flag_alarmONOFF_0 == false)
                {	//alarm ON
           		  Bluetooth_structure_trame BlueCom_Trame_Transmit_test4 = new Bluetooth_structure_trame(CMD_SET_ALARM_DAY_TIME,-1,-1,-1,-1,0,-1,1,-1);   
           		  TransmitFifo.put(BlueCom_Trame_Transmit_test4);  
           		  if (Flag_TimerTask_BC_Transmit == false) MyTimer.scheduleAtFixedRate(new TransmitTask(), 0, BLUECOM_TIME_MS_TIMER_TASK); 
           		mAlarmButtonONOFF_out0.setBackgroundDrawable(getResources().getDrawable(R.drawable.bluecom_button_on));
                }
                else
                {	//alarm OFF
           		  Bluetooth_structure_trame BlueCom_Trame_Transmit_test5 = new Bluetooth_structure_trame(CMD_SET_ALARM_DAY_TIME,-1,-1,-1,-1,0,-1,0,-1);   
           		  TransmitFifo.put(BlueCom_Trame_Transmit_test5);  
           		  if (Flag_TimerTask_BC_Transmit == false) MyTimer.scheduleAtFixedRate(new TransmitTask(), 0, BLUECOM_TIME_MS_TIMER_TASK);
           		mAlarmButtonONOFF_out0.setBackgroundDrawable(getResources().getDrawable(R.drawable.bluecom_button_off));
                }	
        	}
        });    

        /////////////////////////////////////   OUTPUT RGB  LISTENER	//////////////////////////
        imageButton_OnOff_rgb.setOnTouchListener(new OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {

         		if(event.getAction() == MotionEvent.ACTION_DOWN) {
         			if (Flag_imageButton_OnOff_rgb == true) {				

          		       Log.i("BlueCom", "ACTION : Bouton rgb on/off detect true");
          		       //Transmit : output rgb must be OFF
          		       Bluetooth_structure_trame BlueCom_Trame_Transmit_Button_rgb = new Bluetooth_structure_trame(CMD_SET_RGB_OUTPUT,-1,-1,-1,-1,-1,-1,-1,0);   				
          		       TransmitFifo.put(BlueCom_Trame_Transmit_Button_rgb); 
          		       if (Flag_TimerTask_BC_Transmit == false) MyTimer.scheduleAtFixedRate(new TransmitTask(), 0, BLUECOM_TIME_MS_TIMER_TASK); // start timer task if the previous timer task is not running

         			}
         			else if (Flag_imageButton_OnOff_rgb == false) {
 
         		       Log.i("BlueCom", "ACTION : Bouton rgb on/off detect false");
         		       //Transmit : output rgb must be ON
          		       Bluetooth_structure_trame BlueCom_Trame_Transmit_Button_rgb = new Bluetooth_structure_trame(CMD_SET_RGB_OUTPUT,-1,-1,-1,-1,-1,-1,-1,1);   				
          		       TransmitFifo.put(BlueCom_Trame_Transmit_Button_rgb); 
          		       if (Flag_TimerTask_BC_Transmit == false) MyTimer.scheduleAtFixedRate(new TransmitTask(), 0, BLUECOM_TIME_MS_TIMER_TASK); // start timer task if the previous timer task is not running

         			}        			
                } else if (event.getAction() == MotionEvent.ACTION_UP) {
                	//imageButton_OnOff_out0.setImageResource(R.drawable.power_off_button);
                	
                }
                return true;
            }
        });
        
        imageButton_RGB_rgb.setOnTouchListener(new OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {

         		if(event.getAction() == MotionEvent.ACTION_DOWN) {
         			ColorP();  //launch RGB color picker
                } else if (event.getAction() == MotionEvent.ACTION_UP) {
                	
                }
                return true;
            }
        });
        
        mAlarmSettingButton_rgb.setOnClickListener( new View.OnClickListener() {  
     	   @Override
     	   public void onClick(View arg0) {   
     		   //launch alarm setting
     		   Intent TimeIntent = new Intent(BlueComActivity.this, BlueComTimeSet.class);
    		   TimeIntent.putExtra("Output Select",99);	//output RGB  (99)
     		   startActivityForResult(TimeIntent, REQUEST_TIME_SETTING);   		   
     	   }
     	  });
     
     // Initialize the button to perform the output status
     mAlarmButtonONOFF_rgb.setOnClickListener(new View.OnClickListener(){
     	public void onClick(View arg0){
             if (Flag_alarmONOFF_rgb == false)
             {	//alarm ON
        		  Bluetooth_structure_trame BlueCom_Trame_Transmit_test4 = new Bluetooth_structure_trame(CMD_SET_ALARM_DAY_TIME,-1,-1,-1,-1,99,-1,1,-1);   
        		  TransmitFifo.put(BlueCom_Trame_Transmit_test4);  
        		  if (Flag_TimerTask_BC_Transmit == false) MyTimer.scheduleAtFixedRate(new TransmitTask(), 0, BLUECOM_TIME_MS_TIMER_TASK); 
        		mAlarmButtonONOFF_rgb.setBackgroundDrawable(getResources().getDrawable(R.drawable.bluecom_button_on));
             }
             else
             {	//alarm OFF
        		  Bluetooth_structure_trame BlueCom_Trame_Transmit_test5 = new Bluetooth_structure_trame(CMD_SET_ALARM_DAY_TIME,-1,-1,-1,-1,99,-1,0,-1);   
        		  TransmitFifo.put(BlueCom_Trame_Transmit_test5);  
        		  if (Flag_TimerTask_BC_Transmit == false) MyTimer.scheduleAtFixedRate(new TransmitTask(), 0, BLUECOM_TIME_MS_TIMER_TASK);
        		mAlarmButtonONOFF_rgb.setBackgroundDrawable(getResources().getDrawable(R.drawable.bluecom_button_off));
             }	
     	}
     });    
  
    	// Initialize the BluetoothRfcommClient to perform bluetooth connections
        mRfcommClient = new BluetoothRfcommClient(this, mHandler);
        
        BTConnect();

        // Start IHM :
        //BluetoothDevice device = mBluetoothAdapter.getRemoteDevice(address);
        // Attempt to connect to the device
        //mRfcommClient.connect(device);
        
     }
    
    
    private void BTConnect(){
    	Intent serverIntent = new Intent(this, DeviceListActivity.class);
    	startActivityForResult(serverIntent, REQUEST_CONNECT_DEVICE);	
    }
    private void BTDialog(){
    
    Resources res = getResources();	
    	
    AlertDialog.Builder boite;
   boite = new AlertDialog.Builder(this);
   boite.setTitle(R.string.txt_title_diag);
   boite.setIcon(R.drawable.ic_launcher);
   
   String mot1="salut";
   String mot2=res.getString(R.string.Version_Soft);
   String Newligne=System.getProperty("line.separator");
   String resultat=mot1+Newligne+mot2+R.string.bt_connect; 
   boite.setMessage(mot1+Newligne+mot2+Newligne+res.getString(R.string.status_main_c));

   boite.setPositiveButton("Exit", new DialogInterface.OnClickListener() {
      
       public void onClick(DialogInterface dialog, int which) {

       }
       }
   );
   boite.show();
    
    }
    
    
	public int getConnectionState() {
		return mRfcommClient.getState();
	}
	

	
/////////////////////////////      RGB OUTPUT FUNCTION        ////////////////////////////////////////  
    private void ColorP(){
        ColorPickerDialog dialog = new ColorPickerDialog(this, this,RGB_LED_Color,RGB_LED_Alpha);
        dialog.show();	
    }
  
    @Override
    public void colorChanged(int color, int alpha) {

    	int value_red=0;
    	int value_green=0;
    	int value_blue=0;
    	float alpha_float=0;
    	
    	//save these new value in the global variable
    	RGB_LED_Color = color;
    	RGB_LED_Alpha = alpha;
        
    	// read alpha mask  	
    	alpha_float = (float)alpha/255;		//--> %
    	
    	color =color & 0x00FFFFFF;	//delete alpha in color variable
    	
    	// read color
    	value_red = color >> 16;
    	
    	value_green = color & 0x0000FF00;
    	value_green = value_green >> 8;

        value_blue = color & 0x000000FF;
        
        // calcul alpha + color result
        value_red = (int) (value_red * alpha_float);
        value_green = (int) (value_green * alpha_float);
        value_blue = (int) (value_blue * alpha_float);
        
        if (value_red == 255) value_red=254;
        if (value_green == 255) value_green=254;
        if (value_blue == 255) value_blue=254;
        
		Bluetooth_structure_trame BlueCom_Trame_Transmit_green = new Bluetooth_structure_trame(CMD_SET_RGB_OUTPUT,value_red,value_green,value_blue,-1,-1,-1,-1,-1); 
 	    TransmitFifo.put(BlueCom_Trame_Transmit_green);  
  	    if (Flag_TimerTask_BC_Transmit == false) MyTimer.scheduleAtFixedRate(new TransmitTask(), 0, BLUECOM_TIME_MS_TIMER_TASK);   
   
    }

/////////////////////////////   BLUECOM RECEPTION THREAD      ////////////////////////////////////////  
    // The Handler that gets information back from the BluetoothRfcommClient
    private final Handler mHandler = new Handler(){
    	@Override
        public void handleMessage(Message msg){
    	
    	switch (msg.what){
    		case MESSAGE_STATE_CHANGE:
    			switch (msg.arg1){
    			case BluetoothRfcommClient.STATE_CONNECTED:
    				img_bluetooth.setImageResource(R.drawable.bluetooth_blue); 
    				Log.w("BlueCom","BT connected");

    				// change button text:
    				//wakeup trame
    				mConnectButton.setText(R.string.bt_disconnect);
    	        	Bluetooth_structure_trame BlueCom_Trame_Transmit_Connect00 = new Bluetooth_structure_trame(CMD_DONOTHING);   				
    				TransmitFifo.put(BlueCom_Trame_Transmit_Connect00); 
    				
    				// init trame : get type of board and status
    	        	Bluetooth_structure_trame BlueCom_Trame_Transmit_ConnectInit = new Bluetooth_structure_trame(CMD_STATUS_SYSTEMS);   				
    				TransmitFifo.put(BlueCom_Trame_Transmit_ConnectInit); 
		
    				//first trame
    	        	Bluetooth_structure_trame BlueCom_Trame_Transmit_Connect01 = new Bluetooth_structure_trame(CMD_SET_DIGITAL_OUTPUT);   				
    				TransmitFifo.put(BlueCom_Trame_Transmit_Connect01); 
    				
    				// send time/ hour/date : second trame
    				final Calendar c = Calendar.getInstance();
    				Bluetooth_structure_trame BlueCom_Trame_Transmit_Connect02 = new Bluetooth_structure_trame();
    	  		    BlueCom_Trame_Transmit_Connect02.command =CMD_SET_CURRENT_TIME;
    	  		    BlueCom_Trame_Transmit_Connect02.data0 = (byte) dec2bcd(c.get(Calendar.HOUR_OF_DAY)); 
    				BlueCom_Trame_Transmit_Connect02.data1 = (byte) dec2bcd(c.get(Calendar.MINUTE)); 
    				BlueCom_Trame_Transmit_Connect02.data2 = (byte) dec2bcd(c.get(Calendar.SECOND));
    				BlueCom_Trame_Transmit_Connect02.data3 = (byte) dec2bcd(c.get(Calendar.DATE));
    				BlueCom_Trame_Transmit_Connect02.data4 = (byte) dec2bcd((c.get(Calendar.MONTH) + 1));
    				BlueCom_Trame_Transmit_Connect02.data5 = (byte) dec2bcd((c.get(Calendar.YEAR)- 2000)); //2013 --> 13
    				BlueCom_Trame_Transmit_Connect02.data6 = (byte) dec2bcd((c.get(Calendar.DAY_OF_WEEK)-1)); // Sunday = 0, saturday = 6
    				BlueCom_Trame_Transmit_Connect02.data7 = -1; //no change
    				TransmitFifo.put(BlueCom_Trame_Transmit_Connect02); 
    				
    				//trame n°3 : read alarm time for output 0
    	        	Bluetooth_structure_trame BlueCom_Trame_Transmit_Connect03 = new Bluetooth_structure_trame(CMD_READ_ALARM_DAY_TIME,-1,-1,-1,-1,0,-1,-1,-1);   				
    				TransmitFifo.put(BlueCom_Trame_Transmit_Connect03); 
    				
    				//trame n°4 : read alarm time for output RGB
    	        	Bluetooth_structure_trame BlueCom_Trame_Transmit_Connect04 = new Bluetooth_structure_trame(CMD_READ_ALARM_DAY_TIME,-1,-1,-1,-1,99,-1,-1,-1);   				
    				TransmitFifo.put(BlueCom_Trame_Transmit_Connect04); 
    				
    				//trame n°5 :  output RGB
    	        	Bluetooth_structure_trame BlueCom_Trame_Transmit_ConnectRGB = new Bluetooth_structure_trame(CMD_SET_RGB_OUTPUT);   				
    				TransmitFifo.put(BlueCom_Trame_Transmit_ConnectRGB); 
    				
                	if (Flag_TimerTask_BC_Transmit == false) MyTimer.scheduleAtFixedRate(new TransmitTask(), 0, BLUECOM_TIME_MS_TIMER_TASK); // start timer task if the previous timer task is not running

    				break;
    			case BluetoothRfcommClient.STATE_CONNECTING:
    				Log.w("BlueCom","BT connecting...");

    				title_status.setText(R.string.status_main_cc);
    				break;
    			case BluetoothRfcommClient.STATE_NONE:
    				img_bluetooth.setImageResource(R.drawable.bluetooth_black); 
    				Log.w("BlueCom","BT not connected");

    				// change button :
    				title_status.setText(R.string.status_main_nc);
    				mConnectButton.setText(R.string.bt_connect);
    				break;
    			}
    			break;
    		case MESSAGE_READ: // todo: implement receive data buffering*/
    			byte[] readBuf = (byte[]) msg.obj;
				//Log.d("BlueCom", "RECEPTION Trame: D0:" + readBuf[0] + " D1:"+readBuf[1]+ " D2:"+readBuf[2]+ " D3:"+readBuf[3]+ " D4:"+readBuf[4]+ " D5:"+readBuf[5]+ " D6:"+readBuf[6]+ " D7:"+readBuf[7]+ " D8:"+readBuf[8] + " D9:"+readBuf[9] +" D10:"+readBuf[10] +" D11:"+readBuf[11]+ " D12:"+readBuf[12]);
    			// decoding recever Bluecom trame
    			if (readBuf[0]==2 && readBuf[1]==13 && readBuf[12]==3)  // data0==STX(2) && data1==nbr data in trame && last data == ETX (3)
    			{				
    				BlueCom_Trame_Receive.command = readBuf[2];
    				BlueCom_Trame_Receive.data0 = readBuf[3];
    				BlueCom_Trame_Receive.data1 = readBuf[4];
    				BlueCom_Trame_Receive.data2 = readBuf[5];
    				BlueCom_Trame_Receive.data3 = readBuf[6];
    				BlueCom_Trame_Receive.data4 = readBuf[7];
    				BlueCom_Trame_Receive.data5 = readBuf[8];
    				BlueCom_Trame_Receive.data6 = readBuf[9];
    				BlueCom_Trame_Receive.data7 = readBuf[10];
    				
//    				// DATA2 : type of the bluecom board
//        			switch (readBuf[2]){
//            			case 1:
//            				BlueCom_Trame_Receive.BlueCom_Type = BLUECOM_Type.BC_TYPE_1RELAYS;
//            				break;
//            			case 2:
//            				BlueCom_Trame_Receive.BlueCom_Type = BLUECOM_Type.BC_TYPE_4RELAYS;
//            				break;	
//            			}
//        			
//    				// DATA3 : software revision			
//        			BlueCom_Trame_Receive.Soft_Revision = readBuf[3];
//    				// DATA4 :  status : 0=OK, 1=FAIL, 2=DEGRADED, 255=NA				
//        			switch (readBuf[4]){
//        			case 1:
//        				BlueCom_Trame_Receive.Board_Status = BLUECOM_Status.BC_STATUS_OK;
//        				break;
//        			case 2:
//        				BlueCom_Trame_Receive.Board_Status = BLUECOM_Status.BC_STATUS_FAIL;
//        				break;
//        			case 3:
//        				BlueCom_Trame_Receive.Board_Status = BLUECOM_Status.BC_STATUS_DEGRADED;
//        				break;
//        			case 4:
//        				BlueCom_Trame_Receive.Board_Status = BLUECOM_Status.BC_STATUS_OTHER;
//        				break;
//        			default:	
//        				BlueCom_Trame_Receive.Board_Status = BLUECOM_Status.BC_STATUS_DEFAULT;
//        				break;
//        			}	
//        			
//    				// DATA5 : Read the input status :Binaire format : 1=input high state, 0=input low state (8 input Max)		
//        			BlueCom_Trame_Receive.Input_Status = readBuf[5];
//    				// DATA6 : Read the output status :Binaire format : 1=input high state, 0=input low state (8 output Max)			
//        			BlueCom_Trame_Receive.Output_Status = readBuf[6];
//    				

    		      	
    			}
    			else
    			{
    				// bad message or message traited
    				BlueCom_Structure_Receive.Board_Status = BLUECOM_Status.BC_STATUS_NOCONNECTED;  				
    			}			
				// Gestion information receved and command button
				DecodeBlueCom();
    			break;

    		case MESSAGE_DEVICE_NAME:
    			// save the connected device's name
                mConnectedDeviceName = msg.getData().getString(DEVICE_NAME);
                Toast.makeText(getApplicationContext(), "Connected to "
                        + mConnectedDeviceName, Toast.LENGTH_SHORT).show();
    			break;

    		case MESSAGE_TOAST:
    			Toast.makeText(getApplicationContext(), msg.getData().getString(TOAST),
                        Toast.LENGTH_SHORT).show();
    			break;
    		}
    	}
    	
    	
     
    };
/////////////////////////////   DECODING RECEPTION DATA      ////////////////////////////////////////  
    private void DecodeBlueCom(){
    	
    	//Display the status of the board on the "title_status" TextView
    	
    	Resources res = getResources();
    	
    	BLUECOM_Status status = BlueCom_Structure_Receive.Board_Status;
    	switch(status)
    	{
    	case BC_STATUS_NOCONNECTED:  
    		// setup message
    		//String chaine1 = res.getString(R.string.status_main_nc);
    		
    		//title_status.setText(chaine1);
    		//Log.d("BlueCom",chaine1);
    		break;
    		
    	default:
    		// setup message
    		String chaine2 = res.getString(R.string.status_main_c) + " to BlueCom Board";
    		
    		title_status.setText(chaine2);
    		//Log.d("BlueCom",chaine2);
    		break;		
    	}

    	
//    	BLUECOM_Type type = BlueCom_Trame.BlueCom_Type; 
//		switch (type){
//		case BC_TYPE_1RELAYS:
//			title_status.setText(res.getString(R.string.status_main_c));
//			break;
//		case BC_TYPE_4RELAYS:
//			title_status.setText("zzzz");
//			break;
//    }	
		
    	// Commande scan
    	switch(BlueCom_Trame_Receive.command)
    	{
    	case CMD_STATUS_SYSTEMS:  

    		
    		
          	break;	
    	case CMD_SET_DIGITAL_OUTPUT:  
            if(BlueCom_Trame_Receive.data0==0x01)
           	{
            	imageButton_OnOff_out0.setImageResource(R.drawable.power_on_button); 
          		Log.d("BlueCom","Reception : CMD_SET_DIGITAL_OUTPUT : Output 1 : On");
          		Flag_imageButton_OnOff_out0 = true;
          	}
          	if(BlueCom_Trame_Receive.data0==0x00)
          	{
          		imageButton_OnOff_out0.setImageResource(R.drawable.power_off_button); 
          		Log.d("BlueCom","Reception : CMD_SET_DIGITAL_OUTPUT :Output 1 : Off");
          		Flag_imageButton_OnOff_out0 = false; 
          	} 
          	// same code for other output...
          	break;
    	case CMD_SET_RGB_OUTPUT:  
            if(BlueCom_Trame_Receive.data7==0x01)
           	{
            	imageButton_OnOff_rgb.setImageResource(R.drawable.power_on_button_m); 
          		Log.d("BlueCom","Reception : CMD_SET_RGB_OUTPUT : Output RGB : On");
          		Flag_imageButton_OnOff_rgb = true;
          	}
          	if(BlueCom_Trame_Receive.data7==0x00)
          	{
          		imageButton_OnOff_rgb.setImageResource(R.drawable.power_off_button_m); 
          		Log.d("BlueCom","Reception : CMD_SET_RGB_OUTPUT :Output RGB : Off");
          		Flag_imageButton_OnOff_rgb = false; 
          	} 
          	// same code for other output...
          	break;	
    	case CMD_SET_CURRENT_TIME:  
        	Log.d("BlueCom","Reception : CMD_SET_CURRENT_TIME : Date read:" + bcd2dec(BlueCom_Trame_Receive.data0) + "h "+ bcd2dec(BlueCom_Trame_Receive.data1) +"min "+ bcd2dec(BlueCom_Trame_Receive.data2) + "s | day="+
        			bcd2dec(BlueCom_Trame_Receive.data3) +" month="+bcd2dec(BlueCom_Trame_Receive.data4)+ " Year=20"+bcd2dec(BlueCom_Trame_Receive.data5) +" Weekday="+ bcd2dec(BlueCom_Trame_Receive.data6));
          	break;
    	case CMD_READ_CURRENT_TIME:  
        	Log.d("BlueCom","Reception : CMD_READ_CURRENT_TIME : Date read:" + bcd2dec(BlueCom_Trame_Receive.data0) + "h "+ bcd2dec(BlueCom_Trame_Receive.data1) +"min "+ bcd2dec(BlueCom_Trame_Receive.data2) + "s | day="+
        			bcd2dec(BlueCom_Trame_Receive.data3) +" month="+bcd2dec(BlueCom_Trame_Receive.data4)+ " Year=20"+bcd2dec(BlueCom_Trame_Receive.data5) +" Weekday="+ bcd2dec(BlueCom_Trame_Receive.data6));
          	//debug
        	break;
    	case CMD_SET_ALARM_TIME:  
        	Log.d("BlueCom","Reception : CMD_SET_ALARM_TIME : Alarm read:" + bcd2dec(BlueCom_Trame_Receive.data0) + "h "+ bcd2dec(BlueCom_Trame_Receive.data1) +"min "+ bcd2dec(BlueCom_Trame_Receive.data2) + "s | day="+
        			bcd2dec(BlueCom_Trame_Receive.data3) +" month="+bcd2dec(BlueCom_Trame_Receive.data4)+ " Year=20"+bcd2dec(BlueCom_Trame_Receive.data5) +" Weekday="+ bcd2dec(BlueCom_Trame_Receive.data6));
          	break;
    	case CMD_READ_ALARM_TIME:  
        	Log.d("BlueCom","Reception : CMD_READ_ALARM_TIME : Alarm read:" + bcd2dec(BlueCom_Trame_Receive.data0) + "h "+ bcd2dec(BlueCom_Trame_Receive.data1) +"min "+ bcd2dec(BlueCom_Trame_Receive.data2) + "s | day="+
        			bcd2dec(BlueCom_Trame_Receive.data3) +" month="+bcd2dec(BlueCom_Trame_Receive.data4)+ " Year=20"+bcd2dec(BlueCom_Trame_Receive.data5) +" Weekday="+ bcd2dec(BlueCom_Trame_Receive.data6));
        	break;  
    	case CMD_SET_ALARM_DAY_TIME:  
    		String Status_alarm_set;
        	if (BlueCom_Trame_Receive.data5==1) Status_alarm_set = "On"; else Status_alarm_set = "Off";
        	Log.d("BlueCom", "Reception : CMD_SET_ALARM_DAY_TIME : Alarm will start at: "+ bcd2dec(BlueCom_Trame_Receive.data0) + "h "+ bcd2dec(BlueCom_Trame_Receive.data1) +"min "+", Output "+ BlueCom_Trame_Receive.data4 +" will be '"+ Status_alarm_set + "' and will stop at: " + bcd2dec(BlueCom_Trame_Receive.data2) + "h "+ bcd2dec(BlueCom_Trame_Receive.data3) +"min");
        	//change status
        	//display alarm value
        	DecodeBlueCom_display_alarm(BlueCom_Trame_Receive.data4);
	
    		break;
    	case CMD_READ_ALARM_DAY_TIME:  
        	String chaine_info;
    		if (BlueCom_Trame_Receive.data0==-1)
    		{
            	switch(BlueCom_Trame_Receive.data4)
            	{
            	case 0:
	    			//output not configured : display message and quit
	    			chaine_info = res.getString(R.string.txt_alarm_noconfig);
	    			title_alarm_stop_out0.setText(chaine_info);
	    			title_alarm_start_out0.setText(" ");
	    			title_alarm_status_out0.setText(" ");
	    			mAlarmButtonONOFF_out0.setText(R.string.txt_alarm_off); // button off : alarm OFF
	    			mAlarmButtonONOFF_out0.setBackgroundDrawable(getResources().getDrawable(R.drawable.bluecom_button_off));
	    			Flag_alarmONOFF_0 = false;
    			break;
    			
            	case 99:
	        		//output not configured : display message and quit
            		
	        		chaine_info = res.getString(R.string.txt_alarm_noconfig);
	        		title_alarm_stop_rgb.setText(chaine_info);
	        		title_alarm_start_rgb.setText(" ");
	        		title_alarm_status_rgb.setText(" ");
	        		mAlarmButtonONOFF_rgb.setText(R.string.txt_alarm_off); // button off : alarm OFF
	        		mAlarmButtonONOFF_rgb.setBackgroundDrawable(getResources().getDrawable(R.drawable.bluecom_button_off));
	        		Flag_alarmONOFF_rgb = false;
	        		break;
            	}	
    			break; 
    		}
    		    		
    		String Status_alarm_read;
        	if (BlueCom_Trame_Receive.data5==1) Status_alarm_read = "On"; else Status_alarm_read = "Off";
        	Log.d("BlueCom", "Reception : CMD_READ_ALARM_DAY_TIME : Alarm will start at: "+ bcd2dec(BlueCom_Trame_Receive.data0) + "h "+ bcd2dec(BlueCom_Trame_Receive.data1) +"min "+", Output "+ BlueCom_Trame_Receive.data4 +" will be '"+ Status_alarm_read + "' and will stop at: " + bcd2dec(BlueCom_Trame_Receive.data2) + "h "+ bcd2dec(BlueCom_Trame_Receive.data3) +"min ");
        	//change status
        	//display alarm value
        	DecodeBlueCom_display_alarm(BlueCom_Trame_Receive.data4);
        	break; 
    	
    	}	
    }
    
    // display text
    private void DecodeBlueCom_display_alarm(byte output_select){
    	// this function display text message for alarm read
    	String chaine_info;
    	Resources res = getResources();
		String Status_alarm;
    	if (BlueCom_Trame_Receive.data5==1) Status_alarm = "On"; else Status_alarm = "Off";
    	
    	switch(output_select)
    	{
    	case 0:
        	//change status for output 0
    		chaine_info = res.getString(R.string.txt_alarm_start) + " "+ bcd2dec(BlueCom_Trame_Receive.data0) + ":"+ pad(bcd2dec(BlueCom_Trame_Receive.data1));
    		title_alarm_start_out0.setText(chaine_info);
    		chaine_info = res.getString(R.string.txt_alarm_stop) + " "+ bcd2dec(BlueCom_Trame_Receive.data2) + ":"+ pad(bcd2dec(BlueCom_Trame_Receive.data3));
    		title_alarm_stop_out0.setText(chaine_info);
    		chaine_info = res.getString(R.string.txt_alarm_status) + Status_alarm;
    		title_alarm_status_out0.setText(chaine_info);
    		if (BlueCom_Trame_Receive.data6==1) 		{
    			mAlarmButtonONOFF_out0.setText(R.string.txt_alarm_on); // button on : alarm ON
    			Flag_alarmONOFF_0 = true;
    			mAlarmButtonONOFF_out0.setBackgroundDrawable(getResources().getDrawable(R.drawable.bluecom_button_on));
    		}
    		else {
    			mAlarmButtonONOFF_out0.setText(R.string.txt_alarm_off); // button off : alarm OFF
    			Flag_alarmONOFF_0 = false;
    			mAlarmButtonONOFF_out0.setBackgroundDrawable(getResources().getDrawable(R.drawable.bluecom_button_off));
    		}
    		break;
    	case 99:
    		
        	//change status for output RGB
    		chaine_info = res.getString(R.string.txt_alarm_start) + " "+ bcd2dec(BlueCom_Trame_Receive.data0) + ":"+ pad(bcd2dec(BlueCom_Trame_Receive.data1));
    		title_alarm_start_rgb.setText(chaine_info);
    		chaine_info = res.getString(R.string.txt_alarm_stop) + " "+ bcd2dec(BlueCom_Trame_Receive.data2) + ":"+ pad(bcd2dec(BlueCom_Trame_Receive.data3));
    		title_alarm_stop_rgb.setText(chaine_info);
    		chaine_info = res.getString(R.string.txt_alarm_status) + Status_alarm;
    		title_alarm_status_rgb.setText(chaine_info);
    		if (BlueCom_Trame_Receive.data6==1) 		{
    			mAlarmButtonONOFF_rgb.setText(R.string.txt_alarm_on); // button on : alarm ON
    			Flag_alarmONOFF_rgb = true;
    			mAlarmButtonONOFF_rgb.setBackgroundDrawable(getResources().getDrawable(R.drawable.bluecom_button_on));
    		}
    		else {
    			mAlarmButtonONOFF_rgb.setText(R.string.txt_alarm_off); // button off : alarm OFF
    			Flag_alarmONOFF_rgb = false;
    			mAlarmButtonONOFF_rgb.setBackgroundDrawable(getResources().getDrawable(R.drawable.bluecom_button_off));
    		}
    		
    		break;
    	}
	
    }
    
/////////////////////////////   ACTIVITY RECUPERATION RESULT AND DATA      ////////////////////////////////////////
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data){
    	switch (requestCode) {
    	case REQUEST_CONNECT_DEVICE:
    		// When DeviceListActivity returns with a device to connect
    		if (resultCode == Activity.RESULT_OK){
    			// Get the device MAC address
    			String address = data.getExtras().getString(DeviceListActivity.EXTRA_DEVICE_ADDRESS);
    			// Get the BLuetoothDevice object
                BluetoothDevice device = mBluetoothAdapter.getRemoteDevice(address);
                // Attempt to connect to the device
                mRfcommClient.connect(device);
    		}
    		break;
    	case REQUEST_ENABLE_BT:
    		// When the request to enable Bluetooth returns
            if (resultCode == Activity.RESULT_OK){
            	setupIHM();
            }else{
            	// User did not enable Bluetooth or an error occured
                Toast.makeText(this, R.string.bt_not_enabled_leaving, Toast.LENGTH_SHORT).show();
                finish();
            }
    		break;
    	case REQUEST_TIME_SETTING:
    		// When the request 
            if (resultCode == Activity.RESULT_OK){
            	
            	int Clock_hour_alarmR_start; 	
            	int Clock_minute_alarmR_start;
            	int Clock_hour_alarmR_stop; 	
            	int Clock_minute_alarmR_stop;           	
            	int Clock_state_alarmR;
            	int Clock_alarm_active;
            	int Clock_output_select_rtn;
            	
            	// get data
            	String Clock_return_start = data.getExtras().getString(BlueComTimeSet.EXTRA_ALARM_TIME_START);
            	Clock_hour_alarmR_start = data.getExtras().getInt(BlueComTimeSet.EXTRA_ALARM_HOUR_START);    	
            	Clock_minute_alarmR_start = data.getExtras().getInt(BlueComTimeSet.EXTRA_ALARM_MINUTE_START);  
            	String Clock_return_stop = data.getExtras().getString(BlueComTimeSet.EXTRA_ALARM_TIME_STOP);
            	Clock_hour_alarmR_stop = data.getExtras().getInt(BlueComTimeSet.EXTRA_ALARM_HOUR_STOP);    	
            	Clock_minute_alarmR_stop = data.getExtras().getInt(BlueComTimeSet.EXTRA_ALARM_MINUTE_STOP);           	  	
            	Clock_state_alarmR = data.getExtras().getInt(BlueComTimeSet.EXTRA_ALARM_STATE);
            	Clock_alarm_active = 1; //TBD
            	Clock_output_select_rtn = data.getExtras().getInt(BlueComTimeSet.EXTRA_ALARM_OUTPUT_SELECT);
            	
            	if(Clock_hour_alarmR_start == Clock_hour_alarmR_stop && Clock_minute_alarmR_start== Clock_minute_alarmR_stop)
            	{
            		Toast.makeText(this, getResources().getString(R.string.txt_rtn_mess1), Toast.LENGTH_SHORT).show();
            		break;  
            	}

            	/// alarm On or Off ? + maketext on screen + log in console
            	String Clock_string_state;
            	if (Clock_state_alarmR==1) Clock_string_state = "On"; else Clock_string_state = "Off";
            	Toast.makeText(this, getResources().getString(R.string.txt_rtn_mess3) + Clock_return_start + getResources().getString(R.string.txt_rtn_mess4)
            			+ Clock_string_state + getResources().getString(R.string.txt_rtn_mess5) +Clock_return_stop, Toast.LENGTH_SHORT).show();
            	Log.i("BlueCom", "ACTION : Alarm will start at: "+ Clock_return_start +", Output will be '"+ Clock_string_state + "' and will stop at: " +Clock_return_stop);
            	
				// send time/ hour/date : second trame
				final Calendar c = Calendar.getInstance();
				Bluetooth_structure_trame BlueCom_Trame_Transmit_Alarm = new Bluetooth_structure_trame();
	  		    BlueCom_Trame_Transmit_Alarm.command =CMD_SET_ALARM_DAY_TIME;
	  		    BlueCom_Trame_Transmit_Alarm.data0 = (byte) dec2bcd(Clock_hour_alarmR_start); 
				BlueCom_Trame_Transmit_Alarm.data1 = (byte) dec2bcd(Clock_minute_alarmR_start); 
				BlueCom_Trame_Transmit_Alarm.data2 = (byte) dec2bcd(Clock_hour_alarmR_stop);
				BlueCom_Trame_Transmit_Alarm.data3 = (byte) dec2bcd(Clock_minute_alarmR_stop);
				BlueCom_Trame_Transmit_Alarm.data4 = (byte) Clock_output_select_rtn;	// output selected
				BlueCom_Trame_Transmit_Alarm.data5 = (byte) Clock_state_alarmR; 
				BlueCom_Trame_Transmit_Alarm.data6 = (byte) Clock_alarm_active; 
				BlueCom_Trame_Transmit_Alarm.data7 = 0; 
				TransmitFifo.put(BlueCom_Trame_Transmit_Alarm); 	
				
            	if (Flag_TimerTask_BC_Transmit == false) MyTimer.scheduleAtFixedRate(new TransmitTask(), 0, BLUECOM_TIME_MS_TIMER_TASK); // start timer task if the previous timer task is not running
            	
            }else{

                Toast.makeText(this, getResources().getString(R.string.txt_rtn_mess2), Toast.LENGTH_SHORT).show();
            }
    		break;    		
    	}
    }
/////////////////////////////   FIFO STACK      ////////////////////////////////////////
    public class Fifo<E> {
    	
        private List<E> liste;
        /**
         * constructeur standard
         */
        public Fifo() {
                this.liste = new ArrayList<E>();
        }
 
        /**
         * ajoute l'objet à la file
         * @param objet
         */
        public void put(E objet) {
                this.liste.add(objet);
        }
 
        /**
         * récupère l'objet le plus vieux de la file
         * @return un objet
         */
        public E get() {
                E objet = null;
                if (!this.liste.isEmpty()) {
                        objet = this.liste.get(0);
                        this.liste.remove(0);
                }
                return objet;
        }
 
        public void clear() {
                liste.clear();
        }
 
        public boolean isEmpty() {
                return liste.isEmpty();
        }
 
        public int size() {
                return liste.size();
        }
}
    
/////////////////////////////   TRANSMISSION TIMER TASK      ////////////////////////////////////////
    public class TransmitTask extends TimerTask {      

    	public TransmitTask() {
    	}
    	
		@Override
		public void run() {

			if (!TransmitFifo.isEmpty()) {
			   Log.i("BlueCom","Transmit progress : Fifo Transmit size ="+TransmitFifo.size());
		    	if (mRfcommClient.getState() == BluetoothRfcommClient.STATE_CONNECTED) {
		    		BlueCom_Trame_Transmit((Bluetooth_structure_trame)TransmitFifo.get());	// read the fifo stack and transmit by Bluetooth
		    	}
		    	Flag_TimerTask_BC_Transmit = true;	// transmition in progress
			} else {
		     	Log.i("BlueCom","Transmit terminated");
		     	Flag_TimerTask_BC_Transmit = false; // transmition finished
			    this.cancel();						// kill this object
			}
		}	            	
    };  
    
///////////////// BLUECOM TRANSMISSION FUNCTION	/////////////// 
    private void sendMessage(byte[] data){
    	// Check that we're actually connected before trying anything
    	if (mRfcommClient.getState() != BluetoothRfcommClient.STATE_CONNECTED) {
    		Toast.makeText(this, R.string.not_connected, Toast.LENGTH_SHORT).show();
    		return;
    	}
    		mRfcommClient.write(data);
    }
    
    private void BlueCom_Trame_Transmit(Bluetooth_structure_trame pBlueCom_Trame_Transmit){
       	byte cmd[];
       	cmd = new byte[13];
    		cmd[0] = pBlueCom_Trame_Transmit.stx;
     		cmd[1] = pBlueCom_Trame_Transmit.nbr;
     		cmd[2] = pBlueCom_Trame_Transmit.command;
     		cmd[3] = pBlueCom_Trame_Transmit.data0;   
     		cmd[4] = pBlueCom_Trame_Transmit.data1; 
     		cmd[5] = pBlueCom_Trame_Transmit.data2; 
     		cmd[6] = pBlueCom_Trame_Transmit.data3; 
     		cmd[7] = pBlueCom_Trame_Transmit.data4; 
     		cmd[8] = pBlueCom_Trame_Transmit.data5; 
     		cmd[9] = pBlueCom_Trame_Transmit.data6; 
     		cmd[10] = pBlueCom_Trame_Transmit.data7; 
     		cmd[11] = pBlueCom_Trame_Transmit.cks; 
     		cmd[12] = pBlueCom_Trame_Transmit.etx; 
    	   sendMessage(cmd);
       }
        
    
///////////////// VARIABLES FOR TRANSMISSION + RECEPTION TRAME	///////////////
	private class Bluetooth_structure_trame
	{
		byte stx;  // STX=2 : start of message
		byte nbr;  //number of bytes int the message
		byte command;
		byte data0;
		byte data1;
		byte data2;
		byte data3;
		byte data4;
		byte data5;
		byte data6;
		byte data7;
		byte cks;  //CKS (xor of message without cks and etx)
		byte etx;  //ETX=3 : end of message
		
		public Bluetooth_structure_trame(){
			// main variable
			stx=2;	 // STX=2 : start of message
			nbr=13;  //number of bytes int the message
			command=0;
			data0=0;
			data1=0;
			data2=0;
			data3=0;
			data4=0;
			data5=0;
			data6=0;
			data7=0;
			cks =0;  //CKS (xor of message without cks and etx)
			etx=3;   //ETX=3 : end of message
		}
		public Bluetooth_structure_trame(int pcommand,int pdata0,int pdata1,int pdata2,int pdata3,int pdata4,int pdata5,int pdata6,int pdata7){
			// main variable
			stx=2;	 // STX=2 : start of message
			nbr=13;  //number of bytes int the message
			command=(byte) pcommand;
			data0=(byte) pdata0;
			data1=(byte) pdata1;
			data2=(byte) pdata2;
			data3=(byte) pdata3;
			data4=(byte) pdata4;
			data5=(byte) pdata5;
			data6=(byte) pdata6;
			data7=(byte) pdata7;
			cks =0;  //CKS (xor of message without cks and etx)
			etx=3;   //ETX=3 : end of message
		}
		
		public Bluetooth_structure_trame(int pcommand){
			// main variable
			stx=2;	 // STX=2 : start of message
			nbr=13;  //number of bytes int the message
			command=(byte) pcommand;
			data0=-1;
			data1=-1;
			data2=-1;
			data3=-1;
			data4=-1;
			data5=-1;
			data6=-1;
			data7=-1;
			cks =0;  //CKS (xor of message without cks and etx)
			etx=3;   //ETX=3 : end of message
		}
		
	     public void finalize()
	     {
	     }
	}
//////////////////// DATA CONVERTER	///////////////////////
	private int  bcd2dec( int bcd)
	{
	    int dec=0;
	    int mult;
	    for (mult=1; bcd !=0 ; bcd=bcd>>4,mult*=10)
	    {
	        dec += (bcd & 0x0f) * mult;
	    }
	    return dec;
	}
	private int  dec2bcd( int dec)
	{
	    int bcd=0;

	    int unit=0;
	    int dizaine=0;
	    int centaine=0;
	    int milier=0;
	    while (dec>1000)
	    {
	    	milier++;
	    	dec-=1000;
	    }	    
	    while (dec>100)
	    {
	    	centaine++;
	    	dec-=100;
	    }
	    while (dec>10)
	    {
	    	dizaine++;
	    	dec-=10;
	    }    
	    unit =  dec;
	    //Log.i("BlueCom","milier="+ milier+"centaine="+ centaine + "dizaine="+dizaine+"unit="+unit);
	    bcd = milier*4096+ centaine*256 + dizaine*16 + unit;
	    //Log.i("BlueCom","bcd="+ bcd);    
	    return bcd;
	}  
	
	private static String pad(int c) {
		if (c >= 10)
			return String.valueOf(c);
		else
			return "0" + String.valueOf(c);
	}


}
