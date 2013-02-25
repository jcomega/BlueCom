//------------------------------------------------------------------------------
/*! \file BC_pwm.c
 *  \brief PWM for LED RGB generator
 *  \brief
 *  \version v1.0.0
 *  \date 28/12/12
 *  \author JCP
 */
//------------------------------------------------------------------------------
// Version  | Date     | Author         | Modification
//  1.0         28/12/12     jC_Omega       first version 3 PWM output with PWm software
//------------------------------------------------------------------------------

#include "../Includes/BC_pwm.h"
#include "../Includes/GenericTypeDefs.h"

#define PWM_RESOLUTION  255     // max 255
#define PWM_MAXOUTPUT  8     // just 3 for the moment
unsigned char PWM_Value[PWM_MAXOUTPUT];     // 8 PWM value for 8 different output


/*********************************************************************
 * Function:        	void PWM_Init(void)
 * PreCondition:    	none
 * Input:           	none
 * Output:          	none
 * Side Effects:    	None
 * Stack Requirements: 	1 level deep
 * Overview:        	This function initialise the register and the timer of generating PWM software
 ********************************************************************/
void PWM_Init(void)
{
unsigned char temp;

// Timer2 Registers for 32Mhz:
// Prescaler=1:1; TMR2 PostScaler=1:4; PR2=200 - Freq = 10 000,00Hz - Period = 100,00 µs
//T2CON |       = 24;// bits 6-3 Post scaler 1:1 thru 1:16
//T2CON.TOUTPS3 = 0;
//T2CON.TOUTPS2 = 0;
//T2CON.TOUTPS1 = 1;
//T2CON.TOUTPS0 = 1;
//T2CON.TMR2ON  = 1;// Timer2 on bit: 1=Timer2 is on;
//T2CON.T2CKPS1 = 0;// bits 1-0  Prescaler Rate Select bits
//T2CON.T2CKPS0 = 0;
T2CON = 0b00011100;
//PR2 = 200;           // PR2 (Timer2 Match value) // for PWM 100 value
PR2 = 78;           // PR2 (Timer2 Match value) // for PWM 256 value

for (temp=0; temp<PWM_MAXOUTPUT; temp++) PWM_Value[temp]=0;

PIR1bits.TMR2IF = 0;          // clear (reset) flag
PIE1bits.TMR2IE = 1;          // active interruption
IPR1bits.TMR2IP = 0;          // priority

}

/*********************************************************************
 * Function:        	void PWM_Generator(void)
 * PreCondition:    	PWM_Init()function should have been called.
 *                      must be called in the user application's ISR portion.
 * Input:           	none
 *
 * Output:          	none
 *
 * Side Effects:    	None
 * Stack Requirements: 	2 level deep
 * Overview:        	This is the Interrupt service routine which is
 *						called in the user application's ISR portion.
 ********************************************************************/
void PWM_Generator(void)
{
    static UINT16_BITS Buffer_PWM;

    //unsigned char Buffer_PWM_3;
    //unsigned char Buffer_PWM_4;
    //unsigned char Buffer_PWM_5;
    //unsigned char Buffer_PWM_6;
    //unsigned char Buffer_PWM_7;

    static unsigned char PWM_Time=0;

    // rezet timer flag :
   PIR1bits.TMR2IF = 0;          // clear (reset) flag


   if(PWM_Time == 0)
   {
    Buffer_PWM.Val = 0b11111111; //8 buffer output =1
    PWM_OUTPUT0 = 0;
    PWM_OUTPUT1 = 0;
    PWM_OUTPUT2 = 0;

   }

    if (PWM_Time>=PWM_Value[0]) Buffer_PWM.bits.b0 = 0;
    if (PWM_Time>=PWM_Value[1]) Buffer_PWM.bits.b1 = 0;
    if (PWM_Time>=PWM_Value[2]) Buffer_PWM.bits.b2 = 0;
//    if (PWM_Time>=PWM_Value[3]) PWM_OUTPUT3 = 0;
//    if (PWM_Time>=PWM_Value[4]) PWM_OUTPUT4 = 0;
//    if (PWM_Time>=PWM_Value[5]) PWM_OUTPUT5 = 0;
//    if (PWM_Time>=PWM_Value[6]) PWM_OUTPUT6 = 0;
//    if (PWM_Time>=PWM_Value[7]) PWM_OUTPUT7 = 0;
   
    PWM_OUTPUT0 = Buffer_PWM.bits.b0;
    PWM_OUTPUT1 = Buffer_PWM.bits.b1;
    PWM_OUTPUT2 = Buffer_PWM.bits.b2;

    PWM_Time++;
    if (PWM_Time>PWM_RESOLUTION) PWM_Time=0;


}

/*********************************************************************
 * Function:        	unsigned char PWM_Setvalue(unsigned char Value,unsigned char Channel)
 * PreCondition:    	PWM_Init()function should have been called.
 * Input:           	unsigned char
 *                                              Channel - Select channel must be read
 * Input:           	unsigned char
 *                                              Value - put the PWM value
 * Output:          	unsigned char
 *						1 - the value has been set
 *                                              0 - the value has not been set (error)
 * Side Effects:    	None
 * Stack Requirements: 	1 level deep
 * Overview:        	This function returns the value in the PWM_Value register depending of the chanel selected
 ********************************************************************/
unsigned char PWM_Setvalue(unsigned char Value,unsigned char Channel)
{
if(Channel>=PWM_MAXOUTPUT) return 0;
else if(Value==255) return 0;   // if -1 detection then don't change value
else if(Value>=PWM_RESOLUTION) Value=PWM_RESOLUTION;

PWM_Value[Channel]= Value;

return 1;
}

/*********************************************************************
 * Function:        	unsigned char PWM_Readvalue(unsigned char Channel)
 * PreCondition:    	PWM_Init()function should have been called.
 * Input:           	unsigned char
 *                                              Channel - Select channel must be read
 * Output:          	unsigned char
 *						value - value of PWM
 * Side Effects:    	None
 * Stack Requirements: 	1 level deep
 * Overview:        	This function returns the value in the PWM_Value register depending of the chanel selected
 ********************************************************************/
unsigned char PWM_Readvalue(unsigned char Channel)
{
unsigned value;
if(Channel>=PWM_MAXOUTPUT) return 0;

value = PWM_Value[Channel];

return value;
}