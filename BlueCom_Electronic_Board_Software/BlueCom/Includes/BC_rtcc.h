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

#ifndef __BC_RTCC_H__
#define __BC_RTCC_H__

//-------------DEPENDENCE  ---------------------------------------------------//

// Ajout des types standards
#include "../Includes/device.h"  // header file

//-------------DEFINITION ET CONFIGURATION -----------------------------------//



//--------------------------------------------------------------------------------------------------------------------------------------------
/** \name 		P R O T O T Y P E S
*
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
void RTCC_setTimeDate(BLUETOOTH_DATA* pBC_struct);
void RTCC_readTimeDate(BLUETOOTH_DATA* pBC_struct);
void RTCC_setAlarmDate(BLUETOOTH_DATA* pBC_struct);
void RTCC_readAlarmDate(BLUETOOTH_DATA* pBC_struct);
void RTCC_setAlarmTime(BLUETOOTH_DATA* pBC_struct);
void RTCC_readAlarmTime(BLUETOOTH_DATA* pBC_struct);
void RTCC_setAlarmDayTime(BLUETOOTH_DATA* pBC_struct,BLUECOM_ALARM_DAY_STRUCTURE* pAD_struct);
void RTCC_readAlarmDayTime(BLUETOOTH_DATA* pBC_struct,BLUECOM_ALARM_DAY_STRUCTURE* pAD_struct);
void RTCC_SetAlarmRptCount(unsigned char rptCnt);
void RTCC_initAlarmDayTime(BLUECOM_ALARM_DAY_STRUCTURE* pAD_struct, unsigned char output_select);
unsigned char RTCC_checkAlarmDayTime(BLUECOM_ALARM_DAY_STRUCTURE* pAD_struct);
void RTCC_configure(void);
int  bcd2dec( int bcd);

//-------------VARRIABLES EXPORTEES ------------------------------------------//

#endif
