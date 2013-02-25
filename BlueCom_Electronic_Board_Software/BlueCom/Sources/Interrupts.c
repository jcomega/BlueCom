//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \file Interrupts.c
 *	\brief File definition for Interrupts
 *  \version v0.0.0
 *  \date 05/05/12
 *  \author Jean-Christophe Papelard
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------
//		version	|  Date		|  Author   		| 	Modification
//--------------------------------------------------------------------------------------------------------------------------------------------
//		v0.0.1	|  05/05/12	| Jean-Christophe Papelard	|	First version
//--------------------------------------------------------------------------------------------------------------------------------------------

#include "../Includes/device.h"  // header file
#include "../Includes/Interrupts.h"  // header file
#include "../Includes/UARTintC.h"
#include "../Includes/tick.h"
#include "../Includes/Bluecom.h"
#include "../Includes/BC_rtcc.h"
#include "../Includes/BC_pwm.h"

//--------------------------------------------------------------------------------------------------------------------------------------------
//	Global Variables definition
//--------------------------------------------------------------------------------------------------------------------------------------------
#pragma udata   // declare statically allocated uinitialized variables
extern BLUECOM_STRUCTURE BlueCom_Struct;
extern BLUETOOTH_DATA BlueCom_Data_TX, BlueCom_Data_RX;
extern BLUECOM_ALARM_DAY__STRUCTURE RtccAlarmOutput0;

//--------------------------------------------------------------------------------------------------------------------------------------------
/** \name 	High priority interrupt vector
*
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
#pragma code InterruptVectorHigh = 0x08
void InterruptVectorHigh (void)
{
  _asm
    goto InterruptServiceHigh //jump to interrupt routine
  _endasm
}

//--------------------------------------------------------------------------------------------------------------------------------------------
/** \name 	Low priority interrupt vector
*
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
#pragma code InterruptVectorLow = 0x18
void InterruptVectorLow (void)
{
  _asm
    goto InterruptServiceLow //jump to interrupt routine
  _endasm
}

// -------------------- Iterrupt Service Routines --------------------------
#pragma interrupt InterruptServiceHigh  // "interrupt" pragma also for high priority
void InterruptServiceHigh(void)
{
unsigned char AlarmDayTime_return;
    // Check to see what caused the interrupt
    // (Necessary when more than 1 interrupt at a priority level)

    if(PIR3bits.RTCCIF==1)// every seconde depending RtccSetAlarmRpt()
    {
        RTCC_SetAlarmRptCount(10);	//set alarm repeat count
        PIR3bits.RTCCIF=0;

        //alarm check for output 0:
        AlarmDayTime_return = RTCC_checkAlarmDayTime(&RtccAlarmOutput0);
        if (AlarmDayTime_return!=0)
        {
           if (AlarmDayTime_return == 99) SET_DIGITAL_OUTPUT0 =1;      // output ON
           else if (AlarmDayTime_return == 88)  SET_DIGITAL_OUTPUT0 =0;
           BlueCom_Data_TX.Command_return = CMD_SET_DIGITAL_OUTPUT;    //send the new output status to the android device
           BlueCom_Struct.FlagTx = 1; //set to 1, because the reponse trame must be transmit
        }
    }


    //Interrupt programme for UART gestion (TX+RX)
    PIE1bits.TMR2IE = 0;          // desactive interruption PWM
    UARTIntISR();
    PIE1bits.TMR2IE = 1;          // active interruption PWM

    // Check for another interrupt, examples:
    // if (PIR1bits.TMR1IF)     // Timer 1
    // if (PIR1bits.ADIF)       // ADC

}  // return from high-priority interrupt

#pragma interruptlow InterruptServiceLow// "interruptlow" pragma for low priority
void InterruptServiceLow(void)
{
    // Check to see what caused the interrupt
    // (Necessary when more than 1 interrupt at a priority level)

       if  (INTCONbits.TMR0IF)
       {    
           INTCONbits.TMR0IF = 0; 
           TICK_IT();  //update tick timer
       }
      // Timer2 Interrupt- Freq = 10000.00 Hz - Period = 0.000100 seconds
      if (PIR1bits.TMR2IF == 1)          // timer 2 interrupt flag
      {
        PIR1bits.TMR2IF = 0;     // clears TMR2IF       bit 1 TMR2IF: TMR2 to PR2 Match Interrupt Flag bit
        PWM_Generator();

      }

    // Check for another interrupt, examples:
    // if (PIR1bits.TMR1IF)     // Timer 1
    // if (PIR1bits.ADIF)       // ADC
}
