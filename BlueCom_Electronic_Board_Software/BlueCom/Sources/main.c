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
extern BLUECOM_ALARM_DAY__STRUCTURE RtccAlarmOutput0,RtccAlarmOutputRGB;


/** D E C L A R A T I O N S *******************************************/
#pragma code    // declare executable instructions

void main (void)
{
 unsigned char temp=0;

// PIC frequency= 32Mhz
OSCCON = 0;
OSCCONbits.IRCF = 0b111;  // IRCFx = 111 -> 8mhz, if 110 -> 4Mhz
OSCTUNEbits.PLLEN = 1;  // x4 PLL enabled

// Init I/O
TRISD = 0b00000000;     	// PORTD bits 7:0 are all outputs (0)
TRISAbits.TRISA0 = 1;		// TRISA0 input
// Init Timer0
TICK_Init();             // now enables timer interrupt.

// Init ADC
ADC_Init();

// Init PWM generator
PWM_Init();


// Set up global interrupts
RCONbits.IPEN = 1;          // Enable priority levels on interrupts
INTCONbits.GIEL = 1;        // Low priority interrupts allowed
INTCONbits.GIEH = 1;        // Interrupting enabled.
UARTIntInit();
mRtcc_Clear_Intr_Status_Bit;				//clears the RTCC interrupt status bit
RTCC_configure();					//Configure RTCC using library APIs

// Select board version and software revision
BlueCom_Struct.Soft_Revision=VERSION_SOFT_BLUECOM;
BlueCom_Struct.BlueCom_Type = BC_TYPE_1RELAYS_RGBLED;

// init PWM output value
//PWM_Setvalue(50,0); // red
//PWM_Setvalue(0,0); //green
//PWM_Setvalue(50,0); //blue

SET_DIGITAL_OUTPUT0 = 0;
SET_DIGITAL_OUTPUT1 = 0;
SET_DIGITAL_OUTPUT2 = 0;
SET_DIGITAL_OUTPUT3 = 0;
RTCC_initAlarmDayTime(&RtccAlarmOutput0,0); //INIT output alarm day structure
RTCC_initAlarmDayTime(&RtccAlarmOutputRGB,99); //INIT output alarm day structure

while (1)
{

  if(TICK_Is_Elapse(TICK_TX_BLUECOM))
    {
    TICK_Set(TICK_TX_BLUECOM,100);  //1s

    // TEST
    temp++;
    if (temp>6) temp=0;

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
