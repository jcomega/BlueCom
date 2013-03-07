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

#include "../Includes/BlueCom.h"
#include "../Includes/UARTintC.h"
#include "../Includes/BC_rtcc.h"
#include "../Includes/BC_pwm.h"
#include "../Includes/device.h"
#include "BlueCom/Includes/GenericTypeDefs.h"



//--------------------------------------------------------------------------------------------------------------------------------------------
//	Global Variables definition
//--------------------------------------------------------------------------------------------------------------------------------------------
#pragma udata   // declare statically allocated uinitialized variables

unsigned char uBCM_RxBuffer[BLUECOM_RX_BUFFER_SIZE];

//unsigned char uMsgData[BLUECOM_TX_DATA_LENGTH];
BLUECOM_STRUCTURE BlueCom_Struct;
BLUETOOTH_DATA BlueCom_Data_TX, BlueCom_Data_RX;
BLUECOM_ALARM_DAY__STRUCTURE RtccAlarmOutput0,RtccAlarmOutputRGB;
BLUECOM_RGB_PWM_LED__STRUCTURE BlueCom_outputRGB;

#pragma code    // declare executable instructions

//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  unsigned char BCM_ReceiveUART(void)
 *  \brief This fonction read uart fifo and decode trame
 *
 *  \return 1 if data has been receved
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
unsigned char BCM_ReceiveUART(void)
{
    unsigned char uData;
    unsigned int wCpt;
    static unsigned char uRxBuffer[BLUECOM_RX_BUFFER_SIZE];
    static unsigned char uRxIdx;



    if (vUARTIntStatus.UARTIntRxBufferEmpty)             // if fifo is empty, quit this function
        return 0;

    while(!vUARTIntStatus.UARTIntRxBufferEmpty)
    {
        PIE1bits.TMR2IE = 0;          // desactive interruption PWM
        UARTIntGetChar(&uData);


        if(uRxIdx==0)
        {							// Waiting for STX ?
            if (uData==STX)
                    uRxBuffer[uRxIdx++]=uData;		// Place data in buffer, update index and exit
            continue;
        }
        if(uRxIdx==1)
        {							// Waiting for NBR ?
            uRxBuffer[uRxIdx++]=uData;			// Place data in buffer
            continue;
        }
        if(uRxIdx==(uRxBuffer[1]-1))        //if(uRxIdx==(uRxBuffer[1]-1))
        {							// Last byte ?
            uRxBuffer[uRxIdx]=uData;			// Place data in buffer
            uRxIdx=0;					// Reset index to indicate that waiting for stx
            BlueCom_Struct.FlagRx=1;                                   // Set flag message received at 1
            for (wCpt=0;wCpt<uRxBuffer[1];wCpt++) {
                uBCM_RxBuffer[wCpt]=uRxBuffer[wCpt];}	//copy buffer irq into normal buffer
            continue;
        }
        if (uRxIdx>=BLUECOM_RX_BUFFER_SIZE)
        {							// Test is buffer is full
            uRxIdx=0;					// buffer is full, reset index to abort
            continue;
        }							// and exit
        uRxBuffer[uRxIdx++]=uData;				// Place data in buffer, update index and exit (normal data)

        if (vUARTIntStatus.UARTIntRxError)
        {							// if overrun,
            uRxIdx=0;
            vUARTIntStatus.UARTIntRxError=0;
        }
    }

        PIE1bits.TMR2IE = 1;          // active interruption PWM

    return 1;
}
//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  unsigned char BCM_Decode(void)
 *  \brief This fonction decode trame and command the system
 *
 *  \return 1 if a information has been decoded, 0 if the information is bad
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
unsigned char BCM_Decode(void)
{
	if ((uBCM_RxBuffer[0]!=STX) || (uBCM_RxBuffer[1]!=BLUECOM_RX_TRAME_LENGTH) || (uBCM_RxBuffer[BLUECOM_RX_TRAME_LENGTH-1]!=ETX) ) return(0);   // bad trame receved

        BlueCom_Data_RX.Command_return = uBCM_RxBuffer[2];
        BlueCom_Data_RX.Data0 = uBCM_RxBuffer[3];
        BlueCom_Data_RX.Data1 = uBCM_RxBuffer[4];
        BlueCom_Data_RX.Data2 = uBCM_RxBuffer[5];
        BlueCom_Data_RX.Data3 = uBCM_RxBuffer[6];
        BlueCom_Data_RX.Data4 = uBCM_RxBuffer[7];
        BlueCom_Data_RX.Data5 = uBCM_RxBuffer[8];
        BlueCom_Data_RX.Data6 = uBCM_RxBuffer[9];
        BlueCom_Data_RX.Data7 = uBCM_RxBuffer[10];

    switch (BlueCom_Data_RX.Command_return)
    {
    // Application configurations
        case CMD_STATUS_SYSTEMS:
            BlueCom_Data_TX.Command_return = CMD_STATUS_SYSTEMS;
            BlueCom_Struct.FlagTx = 1; //set to 1, because the reponse trame must be transmit
        break;
    // input/output
        case CMD_SET_DIGITAL_OUTPUT:
            if (BlueCom_Data_RX.Data0==1) { SET_DIGITAL_OUTPUT0 =1; RtccAlarmOutput0.Flag_manual_disable =  true; }
            else if (BlueCom_Data_RX.Data0==0) { SET_DIGITAL_OUTPUT0 =0; RtccAlarmOutput0.Flag_manual_disable =  true; }
//                 if (uData1==1) SET_DIGITAL_OUTPUT1 =1;
//                else if (uData1==0) SET_DIGITAL_OUTPUT1 =0;
//                ...
            BlueCom_Data_TX.Command_return = CMD_SET_DIGITAL_OUTPUT;
            BlueCom_Struct.FlagTx = 1; //set to 1, because the reponse trame must be transmit
        break;

        case CMD_SET_PWM:
            PWM_Setvalue(BlueCom_Data_RX.Data0,0); // set PWM value for output 0
            PWM_Setvalue(BlueCom_Data_RX.Data1,1); // set PWM value for output 1
            PWM_Setvalue(BlueCom_Data_RX.Data2,2); // set PWM value for output 2
            PWM_Setvalue(BlueCom_Data_RX.Data3,3); // set PWM value for output 3
            PWM_Setvalue(BlueCom_Data_RX.Data4,4); // set PWM value for output 4
            PWM_Setvalue(BlueCom_Data_RX.Data5,5); // set PWM value for output 5
            PWM_Setvalue(BlueCom_Data_RX.Data6,6); // set PWM value for output 6
            PWM_Setvalue(BlueCom_Data_RX.Data7,7); // set PWM value for output 7
        break;

        case CMD_SET_RGB_OUTPUT:
            // save value
            if (BlueCom_Data_RX.Data0!=255) BlueCom_outputRGB.pwm_red = BlueCom_Data_RX.Data0;
            if (BlueCom_Data_RX.Data1!=255) BlueCom_outputRGB.pwm_green = BlueCom_Data_RX.Data1;
            if (BlueCom_Data_RX.Data2!=255) BlueCom_outputRGB.pwm_blue = BlueCom_Data_RX.Data2;

            if (BlueCom_Data_RX.Data7==1) BlueCom_outputRGB.status = 1;
            else if (BlueCom_Data_RX.Data7==0) BlueCom_outputRGB.status = 0;
            //else no change

            if (BlueCom_outputRGB.status==1)
                {
                 PWM_Setvalue(BlueCom_outputRGB.pwm_red,0); // set PWM value for output 0
                 PWM_Setvalue(BlueCom_outputRGB.pwm_green,1); // set PWM value for output 1
                 PWM_Setvalue(BlueCom_outputRGB.pwm_blue,2); // set PWM value for output 2
                 RtccAlarmOutputRGB.Flag_manual_disable =  true;  //disable alarm if active
                }
            else if (BlueCom_outputRGB.status==0)
                {
                 PWM_Setvalue(0,0); // set PWM value for output 0
                 PWM_Setvalue(0,1); // set PWM value for output 1
                 PWM_Setvalue(0,2); // set PWM value for output 2
                 RtccAlarmOutputRGB.Flag_manual_disable =  true;  //disable alarm if active
                }

            BlueCom_Data_TX.Command_return = CMD_SET_RGB_OUTPUT;
            BlueCom_Struct.FlagTx = 1; //set to 1, because the reponse trame must be transmit
        break;

// TIME AND DATE COMMAND ;
         case CMD_SET_CURRENT_TIME:
            RTCC_setTimeDate(&BlueCom_Data_RX);   //set date and time on this board
            BlueCom_Data_TX.Command_return = CMD_SET_CURRENT_TIME;
            BlueCom_Struct.FlagTx = 1; //set to 1, because the reponse trame must be transmit
        break;

        case CMD_READ_CURRENT_TIME:
            BlueCom_Data_TX.Command_return = CMD_READ_CURRENT_TIME;   //just send for de next transmition the time and data from this board
            BlueCom_Struct.FlagTx = 1; //set to 1, because the reponse trame must be transmit
        break;
        case CMD_SET_ALARM_TIME:
            RTCC_setAlarmTime(&BlueCom_Data_RX);   //set date and time on this board
            BlueCom_Data_TX.Command_return = CMD_SET_ALARM_TIME;
            BlueCom_Struct.FlagTx = 1; //set to 1, because the reponse trame must be transmit
        break;

        case CMD_READ_ALARM_TIME:
            BlueCom_Data_TX.Command_return = CMD_READ_ALARM_TIME;   //just send for de next transmition the time and data from this board
            BlueCom_Struct.FlagTx = 1; //set to 1, because the reponse trame must be transmit
        break;
        case CMD_SET_ALARM_DAY_TIME:
            if(BlueCom_Data_RX.Data4==0) RTCC_setAlarmDayTime(&BlueCom_Data_RX, &RtccAlarmOutput0);   //transfert data recetion to RtccAlarmOutput0 objet for save information
            //else if(BlueCom_Data_RX.Data4==1) RTCC_setAlarmDayTime(&BlueCom_Data_RX, &RtccAlarmOutput1);   //transfert data recetion to RtccAlarmOutput1 objet for save information
            //...
            else if(BlueCom_Data_RX.Data4==99) RTCC_setAlarmDayTime(&BlueCom_Data_RX, &RtccAlarmOutputRGB);   //transfert data recetion to RtccAlarmOutputRGB objet for save information

            BlueCom_Data_TX.Command_return = CMD_SET_ALARM_DAY_TIME;
            BlueCom_Struct.FlagTx = 1; //set to 1, because the reponse trame must be transmit
        break;

        case CMD_READ_ALARM_DAY_TIME:
            BlueCom_Data_TX.Command_return = CMD_READ_ALARM_DAY_TIME;   //just send for de next transmition the time and data from this board
            BlueCom_Struct.FlagTx = 1; //set to 1, because the reponse trame must be transmit
        break;
    }

    return 1;
}

//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  unsigned char BCM_TransmitUART(unsigned char uCommand, unsigned char *uDataPtr, unsigned char uNbrData )
 *  \brief This fonction put trame in uart fifo and transmit
 *
 *  \return 1 if data has been transmit
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
unsigned char BCM_TransmitUART(unsigned char uCommand, unsigned char *uDataPtr, unsigned char uNbrData )
{
    unsigned char uCpt;
    //add data in TX fifo software
    UARTIntPutChar(STX ); // STX=2
    UARTIntPutChar(uNbrData +5 );  //number of bytes int the message
    UARTIntPutChar(uCommand );  //command return for le trame

    for (uCpt=0;uCpt<uNbrData;uCpt++)
    {
        UARTIntPutChar( *uDataPtr++ );
    }
//    UARTIntPutChar(BlueCom_Trame.BlueCom_Type);  // type of the bluecom board
//    UARTIntPutChar(BlueCom_Trame.Soft_Revision); //software revision
//    UARTIntPutChar(BlueCom_Trame.Board_Status); // status : 0=OK, 1=FAIL, 2=DEGRADED, 255=NA
//    UARTIntPutChar(BlueCom_Trame.Input_Status); //Read the input status :Binaire format : 1=input high state, 0=input low state (8 input Max)
//    UARTIntPutChar(BlueCom_Trame.Output_Status); // Read the output status :Binaire format : 1=input high state, 0=input low state (8 output Max)

    UARTIntPutChar(0x00 );  //CKS (xor of message without cks and etx)
    UARTIntPutChar(ETX ); //ETX=3 : end of message

return(1);
}

//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  unsigned char BCM_Transmit(BLUETOOTH_DATA* pBC_struct)
 *  \brief This fonction read data and put trame in transmit buffer
 *
 *  \return 1 if data has been transmit
     */
//--------------------------------------------------------------------------------------------------------------------------------------------
unsigned char BCM_Transmit(BLUETOOTH_DATA* pBC_struct)
{
    //add data in TX fifo software
    UARTIntPutChar(STX ); // STX=2
    UARTIntPutChar(BLUECOM_TX_TRAME_LENGTH );  //number of bytes int the message
    UARTIntPutChar(pBC_struct->Command_return );  //command return for le trame
    UARTIntPutChar(pBC_struct->Data0 );  //data
    UARTIntPutChar(pBC_struct->Data1 );  //data
    UARTIntPutChar(pBC_struct->Data2 );  //data
    UARTIntPutChar(pBC_struct->Data3 );  //data
    UARTIntPutChar(pBC_struct->Data4 );  //data
    UARTIntPutChar(pBC_struct->Data5 );  //data
    UARTIntPutChar(pBC_struct->Data6 );  //data
    UARTIntPutChar(pBC_struct->Data7 );  //data

    UARTIntPutChar(0x00 );  //CKS (xor of message without cks and etx)
    UARTIntPutChar(ETX ); //ETX=3 : end of message

return(1);
}

//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  unsigned char BCM_Encode(void)
 *  \brief This fonction encode the futur trame with data and command from the system
 *
 *  \return 1 if a information has been decoded, 0 if the information is bad
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
unsigned char BCM_Encode(void)
{

    switch (BlueCom_Data_TX.Command_return)
    {
    // Application configurations
        case CMD_STATUS_SYSTEMS:
            BlueCom_Data_TX.Data0 = BC_TYPE_1RELAYS_RGBLED; // type of board
            BlueCom_Data_TX.Data1 = 0xFF;   //board status;
            BlueCom_Data_TX.Data2 = 0xFF;   //Reserved
            BlueCom_Data_TX.Data3 = 0xFF;   //Reserved
            BlueCom_Data_TX.Data4 = 0xFF;   //Reserved
            BlueCom_Data_TX.Data5 = 0xFF;   //Soft_Revision_1
            BlueCom_Data_TX.Data6 = 0xFF;   //Soft_Revision_2
            BlueCom_Data_TX.Data7 = 0xFF;   //Soft_Revision_3
        break;
    // input/output
        case CMD_SET_DIGITAL_OUTPUT:
            // read output status directly on the port
            BlueCom_Data_TX.Data0 = READ_DIGITAL_OUTPUT0;
            BlueCom_Data_TX.Data1 = 0xFF;   //READ_DIGITAL_OUTPUT1;
            BlueCom_Data_TX.Data2 = 0xFF;   //READ_DIGITAL_OUTPUT2;
            BlueCom_Data_TX.Data3 = 0xFF;   //READ_DIGITAL_OUTPUT3;
            BlueCom_Data_TX.Data4 = 0xFF;   //READ_DIGITAL_OUTPUT4;
            BlueCom_Data_TX.Data5 = 0xFF;   //READ_DIGITAL_OUTPUT5;
            BlueCom_Data_TX.Data6 = 0xFF;   //READ_DIGITAL_OUTPUT6;
            BlueCom_Data_TX.Data7 = 0xFF;   //READ_DIGITAL_OUTPUT7;
        break;

        //case CMD_READ_DIGITAL_INPUT:
        // to be write
        //break;

        case CMD_SET_PWM:
            BlueCom_Data_TX.Data0 = PWM_Readvalue(0); // read PWM value for output 0
            BlueCom_Data_TX.Data1 = PWM_Readvalue(1);
            BlueCom_Data_TX.Data2 = PWM_Readvalue(2);
            BlueCom_Data_TX.Data3 = PWM_Readvalue(3);
            BlueCom_Data_TX.Data4 = PWM_Readvalue(4);
            BlueCom_Data_TX.Data5 = PWM_Readvalue(5);
            BlueCom_Data_TX.Data6 = PWM_Readvalue(6);
            BlueCom_Data_TX.Data7 = PWM_Readvalue(7);
        break;

        case CMD_SET_RGB_OUTPUT:
            
            BlueCom_Data_TX.Data0 = BlueCom_outputRGB.pwm_red; // read PWM value for output 0
            BlueCom_Data_TX.Data1 = BlueCom_outputRGB.pwm_green;
            BlueCom_Data_TX.Data2 = BlueCom_outputRGB.pwm_blue;

            BlueCom_Data_TX.Data7 = BlueCom_outputRGB.status;

        break;

        case CMD_SET_CURRENT_TIME:
            RTCC_readTimeDate(&BlueCom_Data_TX);   //read date and time on this board
        break;
        case CMD_READ_CURRENT_TIME:
            RTCC_readTimeDate(&BlueCom_Data_TX);   //read date and time on this board
        break;
        case CMD_SET_ALARM_TIME:
            RTCC_readAlarmTime(&BlueCom_Data_TX);   //read date and time on this board
        break;
        case CMD_READ_ALARM_TIME:
            RTCC_readAlarmTime(&BlueCom_Data_TX);   //read date and time on this board
        break;
        case CMD_SET_ALARM_DAY_TIME:
            if (BlueCom_Data_RX.Data4==0) RTCC_readAlarmDayTime(&BlueCom_Data_TX, &RtccAlarmOutput0);   //transfert RtccAlarmOutput0 objet for load information
            //else if (BlueCom_Data_RX.Data4==1) RTCC_readAlarmDayTime(&BlueCom_Data_TX, &RtccAlarmOutput1);   //transfert RtccAlarmOutput1 objet for load information
            else if (BlueCom_Data_RX.Data4==99) RTCC_readAlarmDayTime(&BlueCom_Data_TX, &RtccAlarmOutputRGB);   //transfert RtccAlarmOutputRGB objet for load information
        break;
        case CMD_READ_ALARM_DAY_TIME:
            if (BlueCom_Data_RX.Data4==0) RTCC_readAlarmDayTime(&BlueCom_Data_TX, &RtccAlarmOutput0);   //transfert RtccAlarmOutput0 objet for load information
            //if (BlueCom_Data_RX.Data4==1) RTCC_readAlarmDayTime(&BlueCom_Data_TX, &RtccAlarmOutput1);   //transfert RtccAlarmOutput objet for load information
            else if (BlueCom_Data_RX.Data4==99) RTCC_readAlarmDayTime(&BlueCom_Data_TX, &RtccAlarmOutputRGB);   //transfert RtccAlarmOutputRGB objet for load information
        break;


    }
}

