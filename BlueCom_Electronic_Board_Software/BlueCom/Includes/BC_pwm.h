//------------------------------------------------------------------------------
/*! \file BC_pwm.h
 *  \brief PWM for LED RGB generator
 *  \brief 
 *  \version v1.0.0
 *  \date 28/12/12
 *  \author JCP
 */
//------------------------------------------------------------------------------
// Version  | Date     | Author         | Modification
//  1.0         28/12/12     jC_Omega
//------------------------------------------------------------------------------

#ifndef __BC_PWM_H__
#define __BC_PWM_H__

//-------------DEPENDENCE  ---------------------------------------------------//

// Ajout des types standards
#include "../Includes/device.h"  // header file

//-------------DEFINITION ET CONFIGURATION -----------------------------------//



//--------------------------------------------------------------------------------------------------------------------------------------------
/** \name 		P R O T O T Y P E S
*
 */
//--------------------------------------------------------------------------------------------------------------------------------------------
void PWM_Init(void);
void PWM_Generator(void);
unsigned char PWM_Readvalue(unsigned char Channel);
unsigned char PWM_Setvalue(unsigned char Value,unsigned char Channel);

//-------------VARRIABLES EXPORTEES ------------------------------------------//

#endif
