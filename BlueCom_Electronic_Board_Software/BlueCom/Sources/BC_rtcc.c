//------------------------------------------------------------------------------
/*! \file BC_rtcc.h
 *  \brief Real time clock gestion
 *  \brief
 *  \version v1.0.0
 *  \date 30/10/12
 *  \author JCP
 */
//------------------------------------------------------------------------------
// Version  | Date     | Author         | Modification
//  1.0         5/11/12     jC_Omega
//------------------------------------------------------------------------------

#include "../Includes/BC_rtcc.h"
#include "rtcc.h"



//-----------------Global structures used in deep sleep library-------------------------------------------------------
rtccTimeDate RtccTimeDate ,RtccAlrmTimeDate, Rtcc_read_TimeDate;
rtccTime  RtccAlrmTime;

void RTCC_setTimeDate(BLUETOOTH_DATA* pBC_struct)
{
   RtccTimeDate.f.hour = pBC_struct->Data0;		//Set Hour
   RtccTimeDate.f.min =  pBC_struct->Data1;		//Set minute
   RtccTimeDate.f.sec =  pBC_struct->Data2;		//Set second
   RtccTimeDate.f.mday = pBC_struct->Data3;		//Set day
   RtccTimeDate.f.mon =  pBC_struct->Data4;		//Se month
   RtccTimeDate.f.year = pBC_struct->Data5; 		//set year
   RtccTimeDate.f.wday = pBC_struct->Data6;  		//Set which day of the week for the corrsponding date
   RtccWriteTimeDate(&RtccTimeDate,1);			//write into registers
}

void RTCC_readTimeDate(BLUETOOTH_DATA* pBC_struct)
{
    RtccReadTimeDate(&Rtcc_read_TimeDate);		//Rtcc_read_TimeDate will have latest time
   pBC_struct->Data0 = Rtcc_read_TimeDate.f.hour;	//Set Hour
   pBC_struct->Data1 = Rtcc_read_TimeDate.f.min;	//Set minute
   pBC_struct->Data2 = Rtcc_read_TimeDate.f.sec;	//Set second
   pBC_struct->Data3 = Rtcc_read_TimeDate.f.mday;	//Set day
   pBC_struct->Data4 = Rtcc_read_TimeDate.f.mon;	//Se month
   pBC_struct->Data5 = Rtcc_read_TimeDate.f.year; 	//set year
   pBC_struct->Data6 = Rtcc_read_TimeDate.f.wday;  	//Set which day of the week for the corrsponding date
   pBC_struct->Data7 = 0xFF;
}

void RTCC_setAlarmTime(BLUETOOTH_DATA* pBC_struct)
{
   RtccAlrmTime.f.hour = pBC_struct->Data0;		//Set Hour
   RtccAlrmTime.f.min =  pBC_struct->Data1;		//Set minute
   RtccAlrmTime.f.sec =  pBC_struct->Data2;		//Set second

   RtccWriteAlrmTime(&RtccAlrmTime);		//write into registers
   mRtccAlrmEnable();                               //enable the rtcc alarm to wake the device up from deep sleep
}

void RTCC_readAlarmTime(BLUETOOTH_DATA* pBC_struct)
{
   RtccReadAlrmTime(&RtccAlrmTime);		//Rtcc_read_TimeDate will have latest time
   pBC_struct->Data0 = RtccAlrmTime.f.hour;         //Set Hour
   pBC_struct->Data1 = RtccAlrmTime.f.min;          //Set minute
   pBC_struct->Data2 = RtccAlrmTime.f.sec;          //Set second
   pBC_struct->Data3 = 0;         //Set day
   pBC_struct->Data4 = 0;          //Se month
   pBC_struct->Data5 = 0; 	//set year
   pBC_struct->Data6 = 0;
   pBC_struct->Data7 = 0;

}
void RTCC_setAlarmDate(BLUETOOTH_DATA* pBC_struct)
{
   RtccAlrmTimeDate.f.hour = pBC_struct->Data0;		//Set Hour
   RtccAlrmTimeDate.f.min =  pBC_struct->Data1;		//Set minute
   RtccAlrmTimeDate.f.sec =  pBC_struct->Data2;		//Set second
   RtccAlrmTimeDate.f.mday = pBC_struct->Data3;		//Set day
   RtccAlrmTimeDate.f.mon =  pBC_struct->Data4;		//Se month
   RtccAlrmTimeDate.f.year = pBC_struct->Data5; 	//set year
   RtccAlrmTimeDate.f.wday = pBC_struct->Data6;  	//Set which day of the week for the corrsponding date
   RtccWriteAlrmTimeDate(&RtccAlrmTimeDate);		//write into registers
   mRtccAlrmEnable();                               //enable the rtcc alarm to wake the device up from deep sleep
}

void RTCC_readAlarmDate(BLUETOOTH_DATA* pBC_struct)
{
   //RtccReadAlrmTimeDate(&Rtcc_read_TimeDate);		//Rtcc_read_TimeDate will have latest time
   pBC_struct->Data0 = RtccAlrmTimeDate.f.hour;         //Set Hour
   pBC_struct->Data1 = RtccAlrmTimeDate.f.min;          //Set minute
   pBC_struct->Data2 = RtccAlrmTimeDate.f.sec;          //Set second
   pBC_struct->Data3 = RtccAlrmTimeDate.f.mday;         //Set day
   pBC_struct->Data4 = RtccAlrmTimeDate.f.mon;          //Se month
   pBC_struct->Data5 = RtccAlrmTimeDate.f.year; 	//set year
   pBC_struct->Data6 = RtccAlrmTimeDate.f.wday;

   pBC_struct->Data7 = 0xFF;
}

void RTCC_setAlarmDayTime(BLUETOOTH_DATA* pBC_struct,BLUECOM_ALARM_DAY__STRUCTURE* pAD_struct)
{
   //Transfert data BLUECOM_ALARM_DAY__STRUCTURE to BLUETOOTH_DATA
   if(pBC_struct->Data0!= -1) pAD_struct->hour_Start = pBC_struct->Data0;		//Set Hour
   if(pBC_struct->Data1!= -1)pAD_struct->min_Start =  pBC_struct->Data1;		//Set minute
   if(pBC_struct->Data2!= -1)pAD_struct->hour_Stop =  pBC_struct->Data2;		//Set hour
   if(pBC_struct->Data3!= -1)pAD_struct->min_Stop = pBC_struct->Data3;		//Set minute
   
   if(pBC_struct->Data4!= -1) pAD_struct->output_select = pBC_struct->Data4;       // select output
   if(pBC_struct->Data5!= -1) pAD_struct->output_status = pBC_struct->Data5; 	//select status 1= On, 0)Off
   if(pBC_struct->Data6!= -1) pAD_struct->Flag_alarm_active = pBC_struct->Data6;  // if =1 alarm active, if 0 alarm disable
   pAD_struct->Flag_manual_disable = false;  //manual button has never been pressed
   pAD_struct->Flag_alarm_current_state =  false;  //for activate the fist time
   pAD_struct->Flag_alarm_previous_state =  false;  //for activate the fist time

}

void RTCC_readAlarmDayTime(BLUETOOTH_DATA* pBC_struct,BLUECOM_ALARM_DAY__STRUCTURE* pAD_struct)
{
   //Transfert data BLUETOOTH_DATA to BLUECOM_ALARM_DAY__STRUCTURE
   pBC_struct->Data0 = pAD_struct->hour_Start;		//Set Hour
   pBC_struct->Data1 = pAD_struct->min_Start;		//Set minute
   pBC_struct->Data2 = pAD_struct->hour_Stop;		//Set hour
   pBC_struct->Data3 = pAD_struct->min_Stop;		//Set minute

   pBC_struct->Data4 = pAD_struct->output_select;       // select output
   pBC_struct->Data5 = pAD_struct->output_status; 	//select status 1= On, 0)Off
   pBC_struct->Data6 = pAD_struct->Flag_alarm_active; // if =1 alarm active, if 0 alarm disable
}

//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  void RTCC_initAlarmDayTime(BLUECOM_ALARM_DAY__STRUCTURE* pAD_struct, unsigned char output_select)
 *  \brief This fonction init by defaut the alarm day structure
 *  output_select = output sall be select
 *  \return none
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
void  RTCC_initAlarmDayTime(BLUECOM_ALARM_DAY__STRUCTURE* pAD_struct, unsigned char output_select)
{

   pAD_struct->hour_Start = 0xFF;		//Set Hour
   pAD_struct->min_Start =  0xFF;		//Set minute
   pAD_struct->hour_Stop =  0xFF;		//Set hour
   pAD_struct->min_Stop = 0xFF;		//Set minute

   pAD_struct->output_select = output_select;       // select output
   pAD_struct->output_status = 1; 	//select status 1= On, 0)Off
   pAD_struct->Flag_alarm_active = 0;  // if =1 alarm active, if 0 alarm disable
   pAD_struct->Flag_manual_disable = false;  //manual button has never been pressed
   pAD_struct->Flag_alarm_current_state =  false;  //for activate the fist time
   pAD_struct->Flag_alarm_previous_state =  false;  //for activate the fist time
}


//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  unsigned char RTCC_checkAlarmDayTime(BLUECOM_ALARM_DAY__STRUCTURE* pAD_struct)
 *  \brief This fonction test BLUECOM_ALARM_DAY__STRUCTURE if alarm must be activate
 *
 *  \return 0 if alarm is not activate, return 99 if alarm has been activated/disabled and muust be ON, return 88 if alarm has been activated/disabled and muust be OFF
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
unsigned char RTCC_checkAlarmDayTime(BLUECOM_ALARM_DAY__STRUCTURE* pAD_struct)
{
    unsigned char checkAlarm;
    int Current_time_min, Alarm_start_min, Alarm_stop_min;

    checkAlarm=0;

    if (pAD_struct->Flag_alarm_active == true)   // alarm active ?
    {
       RtccReadTimeDate(&Rtcc_read_TimeDate);      // read current time

       Current_time_min = (bcd2dec(Rtcc_read_TimeDate.f.hour) * 60)+ bcd2dec(Rtcc_read_TimeDate.f.min) ;
       Alarm_start_min =  (bcd2dec(pAD_struct->hour_Start) * 60)+ bcd2dec(pAD_struct->min_Start) ;
       Alarm_stop_min =  (bcd2dec(pAD_struct->hour_Stop) * 60)+ bcd2dec(pAD_struct->min_Stop) ;

       if (Alarm_start_min < Alarm_stop_min)
           {
           if( Current_time_min >= Alarm_start_min && Current_time_min < Alarm_stop_min) checkAlarm = 1; else  checkAlarm = 0;
           }
       else
           {
           if( Current_time_min >= Alarm_start_min || Current_time_min < Alarm_stop_min) checkAlarm = 1; else  checkAlarm = 0;
           }
    }
/////////////////////////////////////////////////////////////////////////////
    // save previous alarm state:
    pAD_struct->Flag_alarm_previous_state = pAD_struct->Flag_alarm_current_state;

    //if ((checkHour == 1) && (checkMin == 1))
    if (checkAlarm == 1)
    {
        pAD_struct->Flag_alarm_current_state = true; // alarm activate
            // TEST if alarm start
           if (pAD_struct->Flag_alarm_current_state == true && pAD_struct->Flag_alarm_previous_state == false)
           {
               pAD_struct->Flag_manual_disable = false; // init flag

               if (pAD_struct->output_status == 1) return 99;      // output ON
               else  return 88;

           }
    }
    else
    {
        pAD_struct->Flag_alarm_current_state = false; // alarm disable
       // TEST if alarm is finish
        if (pAD_struct->Flag_manual_disable == false) // test if the alarm has not been disabled
        {

           if (pAD_struct->Flag_alarm_current_state == false && pAD_struct->Flag_alarm_previous_state == true )
           {
               if (pAD_struct->output_status == 1) return 88;      // output OFF
               else  return 99;

           }
        }
    }

   return 0;
}

//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  void RTCC_SetAlarmRptCount(unsigned char rptCnt)
 *  \brief The function sets the RTCC alarm repeat rate.
 *  \input rptCnt has to be a value less then 255
 *  \return 0 none
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
void RTCC_SetAlarmRptCount(unsigned char rptCnt)
{
RtccSetAlarmRptCount(rptCnt,1);	//set alarm repeat count
}


void RTCC_configure(void)
{
unsigned int i=0,j=0;


   RtccInitClock();       								//turn on clock source 
   RtccWrOn();            								//write enable the rtcc registers  
   //mRtccSetClockOe(1);									//enable RTCC output on RTCC output pin
   PIE3bits.RTCCIE=1;										//Enable RTCC interrupt
   IPR3bits.RTCCIP = 1;     //High priority interruption
   //Set Date and time using global structures defined in libraries
   RtccTimeDate.f.hour = 0;							//Set Hour
   RtccTimeDate.f.min =  0;							//Set minute
   RtccTimeDate.f.sec =  0;							//Set second
   RtccTimeDate.f.mday = 02;							//Set day
   RtccTimeDate.f.mon =  11;							//Se month
   RtccTimeDate.f.year = 12; 							//set year
   RtccTimeDate.f.wday = 4;  							//Set which day of the week for the corrsponding date


   //Set the alarm time and date using gloabl structures defined in libraries
   RtccAlrmTimeDate.f.hour = RtccTimeDate.f.hour;		//Set Hour
   RtccAlrmTimeDate.f.min =  RtccTimeDate.f.min ;		//Set minute
   RtccAlrmTimeDate.f.sec =  0; //RtccTimeDate.f.sec ;	//alarm after ten seconds
   RtccAlrmTimeDate.f.mday = RtccTimeDate.f.mday;		//Set day
   RtccAlrmTimeDate.f.wday = RtccTimeDate.f.wday;		//Set which day of the week for the corrsponding date 
   RtccAlrmTimeDate.f.mon =  RtccTimeDate.f.mon;		//Se month
   RtccAlrmTimeDate.f.year = RtccTimeDate.f.year;		//set year 

   RtccWriteTimeDate(&RtccTimeDate,1);				//write into registers
   RtccSetAlarmRpt(RTCC_RPT_SEC,1);				//Set the alarm repeat to every seconde
   RtccSetAlarmRptCount(10,1);					//set alarm repeat count
   RtccWriteAlrmTimeDate(&RtccAlrmTimeDate);			//write the time for alarm into alarm registers
   mRtccOn();							//enable the rtcc
   mRtccAlrmEnable();						//enable the rtcc alarm to wake the device up from deep sleep
}  

 int  bcd2dec( int bcd)
{
    int dec=0;
    int mult;
    for (mult=1; bcd !=0 ; bcd=bcd>>4,mult*=10)
    {
        dec += (bcd & 0x0f) * mult;
    }
    return dec;
}
