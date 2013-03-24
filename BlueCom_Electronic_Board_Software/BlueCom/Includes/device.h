//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \file device.h
 *	\brief File definition for the project
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

#ifndef DEVICE_H
#define DEVICE_H

#include "p18f44j11.h"

//#define VERSION_SOFT_BLUECOM		06 	// 1.0.
#define SOFT_REVISION_1     0
#define SOFT_REVISION_2     9
#define SOFT_REVISION_3     4
// Version = SOFT_REVISION_1.SOFT_REVISION_2.SOFT_REVISION_3
// example : 0.9.3

#define BLUECOM_BOARD_TYPE BC_TYPE_1RELAYS_RGBLED       // select type of board



#define BC_TYPE_1RELAYS             1    // only 1 relay output
#define BC_TYPE_4RELAYS             2    // 4 relay output
#define BC_TYPE_1RELAYS_RGBLED      3    // 1 relay output and 3 PWM output for controling RGB LED projector

//--------------------------------------------------------------------------------------------------------------------------------------------
/** \name 		P R O T O T Y P E S
*
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
void Timer0_Init(void);
void ADC_Init(void);
unsigned char ADC_Convert(void);

//--------------------------------------------------------------------------------------------------------------------------------------------
/** \name 		 D E C L A R A T I O N S
*
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
typedef enum {false, true} Bool;

//--------------------------------------------------------------------------------------------------------------------------------------------
/** \name 		Definition  for main flag for this programme :
*
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
//@{
//! \name Definition  for main flag for this programme
//#define Flag_Uart1_Rec					MainFlags.bits.b0			//= 1 if a frame code has been receved (BLuetooth-->board)
//#define Flag_Uart1_Send					MainFlags.bits.b1			//= 1 if a frame code must be sent (board-->BLuetooth)

//@}

#define Switch_Pin      PORTBbits.RB0
#define DetectsInARow   5

//--------------------------------------------------------------------------------------------------------------------------------------------
/** \name 		External references definition for PORT I/O :
*
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
//@{
//! \name UART for config,debug,bluetooth:
    #define TX_PIC_TRIS TRISCbits.TRISC6
    #define RX_PIC_TRIS TRISCbits.TRISC7
//@}
//@{
//! \name Input/output for port:
    #define SET_DIGITAL_OUTPUT0 LATDbits.LATD0
    #define SET_DIGITAL_OUTPUT1 LATDbits.LATD1
    #define SET_DIGITAL_OUTPUT2 LATDbits.LATD2
    #define SET_DIGITAL_OUTPUT3 LATDbits.LATD3
//    #define SET_DIGITAL_OUTPUT4 xxx;
//    #define SET_DIGITAL_OUTPUT5 xxx;
//    #define SET_DIGITAL_OUTPUT6 xxx;
//    #define SET_DIGITAL_OUTPUT7 xxx;

    #define READ_DIGITAL_OUTPUT0 PORTDbits.RD0
    #define READ_DIGITAL_OUTPUT1 PORTDbits.RD1
    #define READ_DIGITAL_OUTPUT2 PORTDbits.RD2
    #define READ_DIGITAL_OUTPUT3 PORTDbits.RD3
//    #define READ_DIGITAL_OUTPUT4 xxx;
//    #define READ_DIGITAL_OUTPUT5 xxx;
//    #define READ_DIGITAL_OUTPUT6 xxx;
//    #define READ_DIGITAL_OUTPUT7 xxx;

//    #define READ_DIGITAL_INPUT0 xxx;
//    #define READ_DIGITAL_INPUT1 xxx;
//    #define READ_DIGITAL_INPUT2 xxx;
//    #define READ_DIGITAL_INPUT3 xxx;
//    #define READ_DIGITAL_INPUT4 xxx;
//    #define READ_DIGITAL_INPUT5 xxx;
//    #define READ_DIGITAL_INPUT6 xxx;
//    #define READ_DIGITAL_INPUT7 xxx;

    #define PWM_OUTPUT0 LATDbits.LATD1    // PWM output for red (test)
    #define PWM_OUTPUT1 LATDbits.LATD2    // PWM output for green (test)
    #define PWM_OUTPUT2 LATDbits.LATD3    // PWM output for blue (test)
    //#define PWM_OUTPUT3 LATDbits.LATD4    // PWM output for
    //... TBD

//@}
//--------------------------------------------------------------------------------------------------------------------------------------------
//	Enumeration definition
//--------------------------------------------------------------------------------------------------------------------------------------------

typedef enum
{
BC_STATUS_OK= 1,
BC_STATUS_FAIL,
BC_STATUS_DEGRADED,
BC_STATUS_OTHER
}BLUECOM_Status;

//--------------------------------------------------------------------------------------------------------------------------------------------
/** \name 		E X T E R N S : declare variables accessible by other files.
*
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
typedef struct {
BLUECOM_Status Board_Status;

unsigned char FlagRx;    // = 1 if a message has been receved
unsigned char FlagTx;    // = 1 if a message must be transmit

}BLUECOM_STRUCTURE;

typedef struct {

unsigned char Command_return;
unsigned char Data0;
unsigned char Data1;
unsigned char Data2;
unsigned char Data3;
unsigned char Data4;
unsigned char Data5;
unsigned char Data6;
unsigned char Data7;
}BLUETOOTH_DATA;

typedef struct {
    // BCD code
unsigned char hour_Start;   // min = 0x00 max=0x23
unsigned char min_Start;    // min = 0x00 max=0x59
unsigned char hour_Stop;     // min = 0x00 max=0x23
unsigned char min_Stop;     // min = 0x00 max=0x59

unsigned char output_select; // 0 at 7 for 8 output // or 99 for RGB led projector
unsigned char output_status; // 1= output ON
Bool    Flag_alarm_active;  //= true if alarm is active
Bool    Flag_alarm_current_state;  //= true if alarm is activate
Bool    Flag_alarm_previous_state;  //= true if alarm is activate
Bool    Flag_manual_disable;  //= true si alarm is disabled during activating (button for example)
}BLUECOM_ALARM_DAY_STRUCTURE;

typedef struct {

unsigned char pwm_red;       // PWM value for red
unsigned char pwm_green;    // PWM value for green
unsigned char pwm_blue;     // PWM value for blue

unsigned char status;  // 1= output active
}BLUECOM_RGB_PWM_LED_STRUCTURE;

//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  GetSystemClock()
*  \brief This macro returns the system clock frequency in Hertz.
*			value is 8 MHz x 4 PLL for PIC24F
*			value is 8 MHz/2 x 18 PLL for PIC32
*                       value is x MHz x 4 PLL for PIC18F
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
        #define GetSystemClock()    (32000000ul)
// you must define too : UARTIntC.h     UART_CLOCK_FREQ

//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  GetPeripheralClock()
*  \brief This macro returns the peripheral clock frequency used in Hertz.
*			 value for PIC24 is <PRE>(GetSystemClock()/2) </PRE>
*			value for PIC32 is <PRE>(GetSystemClock()/(1<<OSCCONbits.PBDIV)) </PRE>
*
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
        #define GetPeripheralClock()    (GetSystemClock() / 4)

//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  GetInstructionClock()
*  \brief This macro returns instruction clock frequency  used in Hertz.
*			 value for PIC24 is <PRE>(GetSystemClock()/2) </PRE>
*			value for PIC32 is <PRE>(GetSystemClock()) </PRE>
*                       value for PIC18 is <PRE>(GetSystemClock()/4) </PRE>
*/
//--------------------------------------------------------------------------------------------------------------------------------------------
        #define GetInstructionClock()   (GetSystemClock() / 4)


#endif
