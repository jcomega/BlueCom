//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \file Interrupts.h
 *	\brief File definition for BlueCom
 *  \version v0.0.0
 *  \date 15/05/12
 *  \author Jean-Christophe Papelard
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------
//		version	|  Date		|  Author   		| 	Modification
//--------------------------------------------------------------------------------------------------------------------------------------------
//		v0.0.1	|  15/05/12	| Jean-Christophe Papelard	|	First version
//--------------------------------------------------------------------------------------------------------------------------------------------


#ifndef BLUECOM_H
#define BLUECOM_H

#include "../Includes/device.h"  // header file

#define BLUECOM_TX_BUFFER_SIZE 13
#define BLUECOM_TX_TRAME_LENGTH 13
#define BLUECOM_TX_DATA_LENGTH 8
#define BLUECOM_RX_BUFFER_SIZE 13
#define BLUECOM_RX_TRAME_LENGTH 13
#define	STX	2
#define	ETX	3

// Bluetooth command with uart
#define CMD_STATUS_SYSTEMS		0x01		//

#define CMD_SET_CURRENT_TIME		0x10		//
#define CMD_READ_CURRENT_TIME		0x11		//
#define CMD_SET_ALARM_TIME		0x12		//
#define CMD_READ_ALARM_TIME		0x13		//
#define CMD_SET_ALARM_DAY_TIME		0x14		//
#define CMD_READ_ALARM_DAY_TIME		0x15		//

#define CMD_SET_DIGITAL_OUTPUT		0x20		//set output
#define CMD_READ_DIGITAL_INPUT		0x21		//read input
#define CMD_SET_PWM                  	0x22		//set PWM
#define CMD_SET_ANALOG_OUTPUT          	0x23
#define CMD_READ_ANALOG_INPUT          	0x24
#define CMD_SET_RGB_OUTPUT          	0x25            //set LED RGB Output

//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  unsigned char DecodeUART(void)
 *  \brief This fonction read uart fifo and decode trame
 *
 *  \return void
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
unsigned char BCM_ReceiveUART(void);

//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  unsigned char BCM_Decode(void)
 *  \brief This fonction decode trame and command the system
 *
 *  \return 1 if a information has been decoded
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
unsigned char BCM_Decode(void);

//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  unsigned char BCM_TransmitUART(unsigned char uCommand, unsigned char *uDataPtr, unsigned char uNbrData )
 *  \brief This fonction put trame in uart fifo and transmit
 *
 *  \return 1 if data has been transmit
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
unsigned char BCM_TransmitUART(unsigned char uCommand, unsigned char *uDataPtr, unsigned char uNbrData );

//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  unsigned char BCM_Transmit(BLUETOOTH_DATA* pBC_struct);
 *  \brief This fonction read data and put trame in transmit buffer
 *
 *  \return 1 if data has been transmit
     */
//--------------------------------------------------------------------------------------------------------------------------------------------
unsigned char BCM_Transmit(BLUETOOTH_DATA* pBC_struct);

//--------------------------------------------------------------------------------------------------------------------------------------------
/*! \fn  unsigned char BCM_Encode(void)
 *  \brief This fonction encode the futur trame with data and command from the system
 *
 *  \return 1 if a information has been decoded, 0 if the information is bad
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
unsigned char BCM_Encode(void);

#endif