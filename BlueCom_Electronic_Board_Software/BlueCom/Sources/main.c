//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \file main.c
 *	\brief File definition for the project BlueCom
 *  \version v0.0.0
 *  \date 05/05/12
 *  \author Jean-Christophe Papelard
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------
//		version	|  Date		|  Author   		| 	Modification
//--------------------------------------------------------------------------------------------------------------------------------------------
//		v0.0.1	|  05/05/12	| Jean-Christophe Papelard	|	Creation
//		v1.0.0	|  11/05/13	| Jean-Christophe Papelard	|	First final version : 1 relay output version and 1 relay + RBG led output
//--------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------
//	External dependency definition
//--------------------------------------------------------------------------------------------------------------------------------------------

#include "../Includes/device.h"  // header file
#include "../Includes/Interrupts.h"
#include "../Includes/UARTintC.h"
#include "../Includes/BlueCom.h"
#include "../Includes/Tick.h"
#include "../Includes/BC_rtcc.h"
#include "../Includes/BC_pwm.h"
#include "rtcc.h"
//--------------------------------------------------------------------------------------------------------------------------------------------
//	Programme Functionnality
//--------------------------------------------------------------------------------------------------------------------------------------------
/*
 *  - 1 relay output version
 *  - 1 relay + RBG led output
 *
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
//	PIC Fuses references definition
//--------------------------------------------------------------------------------------------------------------------------------------------

#pragma config XINST = OFF ,STVREN = ON,WDTEN = OFF                      // CONFIG1L
#pragma config CP0 = OFF                                                 // CONFIG1H
#pragma config FCMEN = OFF, IESO = OFF, LPT1OSC = OFF, T1DIG = OFF, OSC = INTOSCPLL       // CONFIG2L
#pragma config WDTPS = 32768    // CONFIG2H
#pragma config DSWDTPS = K32, DSWDTEN = OFF, DSBOREN = OFF, RTCOSC = T1OSCREF, DSWDTOSC = T1OSCREF    // CONFIG3L
#pragma config WPEND = PAGE_WPFP, WPCFG = OFF, WPDIS = OFF

//--------------------------------------------------------------------------------------------------------------------------------------------
//	Global Variables definition
//--------------------------------------------------------------------------------------------------------------------------------------------
#pragma udata   // declare statically allocated uinitialized variables
extern BLUECOM_STRUCTURE BlueCom_Struct;
extern BLUETOOTH_DATA BlueCom_Data_TX, BlueCom_Data_RX;
extern BLUECOM_ALARM_DAY_STRUCTURE RtccAlarmOutput0,RtccAlarmOutputRGB;
extern BLUECOM_RGB_PWM_LED_STRUCTURE BlueCom_outputRGB;

/** D E C L A R A T I O N S *******************************************/
#pragma code    // declare executable instructions

void main (void)
{
 unsigned char prev_input0=1;
 unsigned char prev_input1=1;

// PIC frequency= 32Mhz
OSCCON = 0;
OSCCONbits.IRCF = 0b111;    // IRCFx = 111 -> 8mhz, if 110 -> 4Mhz
OSCTUNEbits.PLLEN = 1;      // x4 PLL enabled

// Init I/O
TRIS_DIGITAL_OUTPUT0 = 0; //output: relay
TRIS_DIGITAL_OUTPUT1 = 0; //output: PWM RED LED
TRIS_DIGITAL_OUTPUT2 = 0; //output: PWM GREEN LED
TRIS_DIGITAL_OUTPUT3 = 0; //output: PWM BLUE LED

TRIS_DIGITAL_INPUT0 = 1; // Input : Manual button ON/OFF for relay 1 output
TRIS_DIGITAL_INPUT1 = 1; // Input : Manual button ON/OFF for LED RGB output

// Init Timer0
TICK_Init();             // now enables timer interrupt.

// Init ADC
ADC_Init(); // no tested and implemented

// Set up global interrupts
RCONbits.IPEN = 1;          // Enable priority levels on interrupts
INTCONbits.GIEL = 1;        // Low priority interrupts allowed
INTCONbits.GIEH = 1;        // Interrupting enabled.
UARTIntInit();
mRtcc_Clear_Intr_Status_Bit;				//clears the RTCC interrupt status bit
RTCC_configure();					//Configure RTCC using library APIs

// Select board version and software revision
BlueCom_Struct.Board_Status = BC_STATUS_OK;

// Init for relay routput
SET_DIGITAL_OUTPUT0 = 0;
SET_DIGITAL_OUTPUT1 = 0;
SET_DIGITAL_OUTPUT2 = 0;
SET_DIGITAL_OUTPUT3 = 0;
RTCC_initAlarmDayTime(&RtccAlarmOutput0,0); //INIT output alarm day structure


// SPECIAL FOR FOR VERSION : 1 RELAY + 1 LED RGB OUTPUT
PWM_Init();                     // Init PWM generator
TRIS_LED_RGB_STATUS_OUT = 0 ;   //out
SET_LED_RGB_STATUS_OUT = 0 ;
BlueCom_outputRGB.status=0;
BlueCom_outputRGB.pwm_red = 128;
BlueCom_outputRGB.pwm_green = 128;
BlueCom_outputRGB.pwm_blue = 115;
RTCC_initAlarmDayTime(&RtccAlarmOutputRGB,99); //INIT output alarm day structure

while (1)
    {

      if(TICK_Is_Elapse(TICK_TX_BLUECOM))
      {
        TICK_Set(TICK_TX_BLUECOM,1000);  //1s

      }

      if(TICK_Is_Elapse(TICK_BUTTON_SCAN))
      {
        TICK_Set(TICK_BUTTON_SCAN,10);  //10ms
        // FOR BUTTON 0 (Output 1 for relay)
        if (READ_DIGITAL_INPUT0 == 0) // if the button has been pressed
            {
                if ( prev_input0 != 0)  //debounce methode
                {
                    if (READ_DIGITAL_OUTPUT0==0) { SET_DIGITAL_OUTPUT0 =1; RtccAlarmOutput0.Flag_manual_disable =  true; }
                    else if (READ_DIGITAL_OUTPUT0==1) { SET_DIGITAL_OUTPUT0 =0; RtccAlarmOutput0.Flag_manual_disable =  true; }
                    BlueCom_Data_TX.Command_return = CMD_SET_DIGITAL_OUTPUT;
                    BlueCom_Struct.FlagTx = 1; //set to 1, because the reponse trame must be transmit
                }
                prev_input0 = READ_DIGITAL_INPUT0;  // save current state (0)
            }
        else prev_input0=READ_DIGITAL_INPUT0;   // save current state (1)

#if (BLUECOM_BOARD_TYPE == BC_TYPE_1RELAYS_RGBLED)  //rgb led input only
        // FOR BUTTON 1 ( RGB LED command)
        if (READ_DIGITAL_INPUT1 == 0) // if the button has been pressed
            {
                if ( prev_input1 != 0)  //debounce methode
                {
                    if (BlueCom_outputRGB.status==0)    // if RGB LED is OFF : switch ON the LED !
                        {
                         BlueCom_outputRGB.status=1;    // change status : because led is ON now
                         PWM_Setvalue(BlueCom_outputRGB.pwm_red,0); // set PWM value for output 0
                         PWM_Setvalue(BlueCom_outputRGB.pwm_green,1); // set PWM value for output 1
                         PWM_Setvalue(BlueCom_outputRGB.pwm_blue,2); // set PWM value for output 2
                         RtccAlarmOutputRGB.Flag_manual_disable =  true;  //disable alarm if active
                         SET_LED_RGB_STATUS_OUT = 1 ; // status LED is on
                        }
                    else if (BlueCom_outputRGB.status==1) // if RGB LED is ON : switch OFF the LED !
                        {
                         BlueCom_outputRGB.status=0;    // change status : because led is OFF now
                         PWM_Setvalue(0,0); // set PWM value for output 0
                         PWM_Setvalue(0,1); // set PWM value for output 1
                         PWM_Setvalue(0,2); // set PWM value for output 2
                         RtccAlarmOutputRGB.Flag_manual_disable =  true;  //disable alarm if active
                         SET_LED_RGB_STATUS_OUT = 0 ; // status LED is off
                        }
                    BlueCom_Data_TX.Command_return = CMD_SET_RGB_OUTPUT;
                    BlueCom_Struct.FlagTx = 1; //set to 1, because the reponse trame must be transmit
                }
                prev_input1 = READ_DIGITAL_INPUT1;  // save current state (0)
            }
        else prev_input1=READ_DIGITAL_INPUT1;   // save current state (1)
#endif

      }
      // Bluetooth Reception gestion
      BCM_ReceiveUART();  // read RX buffer if a byte or trame has been receved

      if(BlueCom_Struct.FlagRx) // if data trame has been receved
        {
          BlueCom_Struct.FlagRx=0;  // reset flag
          BCM_Decode();  //decode trame only if a true message has been receved
        }

      if (BlueCom_Struct.FlagTx) // if data trame must be send
      {
          BlueCom_Struct.FlagTx = 0; //reset flag
          BCM_Encode();
          BCM_Transmit(&BlueCom_Data_TX); // transmit command return + data
      }

    }
}

void ADC_Init(void)
{ // initialize the Analog-To-Digital converter.
    // First, we need to make sure the AN0 pin is enabled as an analog input
    // as the demo board potentiometer is connected to RA0/AN0
    // Don't forget that RB0/AN12 must be digital!
	ANCON0 = 0xFF;	//turn off all other analog inputs
	ANCON1 = 0x1F;
 	ANCON0bits.PCFG0 = 0;	// turn on RA0 analog

    // Sets bits VCFG1 and VCFG0 in ADCON1 so the ADC voltage reference is VSS to VDD
    ADCON0bits.VCFG1 =0;
    ADCON0bits.VCFG0 =0;

    // The ADC clock must as short as possible but still greater than the
    // minimum TAD time, datasheet parameter 130.  At the time this lesson was
    // written TAD minimum for the PIC18F45K20 is 1.4us.
    // At 1MHz clock, selecting ADCS = FOSC/2 = 500kHz.  One clock period
    // 1 / 500kHz = 2us, which greater than minimum required 1.4us.
    // So ADCON2 bits ADCS2-0 = 000
    //
    // The ACQT aquisition time should take into accound the internal aquisition
    // time TACQ of the ADC, datasheet paramter 130, and the settling time of
    // of the application circuit connected to the ADC pin.  Since the actual
    // settling time of the RC circuit with the demo board potentiometer is very
    // long but accuracy is not very important to this demo, we'll set ACQT2-0 to
    // 20TAD = 111
    //
    // ADFM = 0 so we can easily read the 8 Most Significant bits from the ADRESH
    // Special Function Register
    ADCON1 = 0b00111000;

    // Select channel 0 (AN0) to read the potentiometer voltage
    ADCON0bits.CHS = 0 ; //AN0
    //and turn on ADC
    ADCON0bits.ADON = 1;
}

unsigned char ADC_Convert(void)
{ // start an ADC conversion and return the 8 most-significant bits of the result
    ADCON0bits.GO_DONE = 1;             // start conversion
    while (ADCON0bits.GO_DONE == 1);    // wait for it to complete
    return ADRESH;                      // return high byte of result
}
