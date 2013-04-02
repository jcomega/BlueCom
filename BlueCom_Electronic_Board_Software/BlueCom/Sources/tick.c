//------------------------------------------------------------------------------
/*! \file tick.c
 *  \brief Tick system Module
 *  \brief 
 *  \version v1.6.0
 *  \date 05/10/12
 *  \author LCT-JCP (PIC18F version)
 */
//------------------------------------------------------------------------------

//-------------DEPENDENCE  ---------------------------------------------------//


#include "../Includes/device.h"
#include "../Includes/tick.h"



//-------------VARRIABLE -----------------------------------------------------//

// Table contenant les valeurs courante des ticks
unsigned int wTICK_Table[TICK_MAX]; //65,735s max

//-------------PROTOTYPE DES FONCTIONS NON EXPORTEES -------------------------//

//-------------DEFINITION DES FONCTIONS --------------------------------------//

//------------------------------------------------------------------------------
/*! \fn    bool TICK_Init(void)
 *  \brief  Fonction d'initialisation du module
 *
 *  Initialise le timer et les varrialbes globales
 *  \return bool : true si l'initialisation a reussi, false sinon
 */
//------------------------------------------------------------------------------
void TICK_Init(void)
{
   // index
   int i;
   // initialisation du timer
    // Set up Interrupts for timer
    INTCONbits.TMR0IF = 0;          // clear roll-over interrupt flag
    INTCON2bits.TMR0IP = 0;         // Timer0 is low priority interrupt
    INTCONbits.TMR0IE = 1;          // enable the Timer0 interrupt.
    // Set up timer itself
    //T0CON = 0b00000001; //for 10ms            // prescale 1:4 - about 1 second maximum delay.
    // Timer0 Registers:// 16-Bit Mode; Prescaler=1:1; TMRH Preset=E0; TMRL Preset=C0; Freq=1 000,00Hz; Period=1,00 ms
    T0CONbits.TMR0ON = 0;// Timer0 On/Off Control bit:1=Enables Timer0 / 0=Stops Timer0
    T0CONbits.T08BIT = 0;// Timer0 8-bit/16-bit Control bit: 1=8-bit timer/counter / 0=16-bit timer/counter
    T0CONbits.T0CS   = 0;// TMR0 Clock Source Select bit: 0=Internal Clock (CLKO) / 1=Transition on T0CKI pin
    T0CONbits.T0SE   = 0;// TMR0 Source Edge Select bit: 0=low/high / 1=high/low
    T0CONbits.PSA    = 1;// Prescaler Assignment bit: 0=Prescaler is assigned; 1=NOT assigned/bypassed
    T0CONbits.T0PS2  = 0;// bits 2-0  PS2:PS0: Prescaler Select bits
    T0CONbits.T0PS1  = 0;
    T0CONbits.T0PS0  = 0;
   // initialisation de tout les ticks
   for (i=0;i<TICK_MAX;i++)wTICK_Table[i]=0;
    TMR0H = 0;                      // clear timer - always write upper byte first
    TMR0L = 0;
    INTCONbits.TMR0IF = 0;          // clear (reset) flag
    T0CONbits.TMR0ON = 1;           // start timer
}

//------------------------------------------------------------------------------
/*! \fn    void TICK_IT(void)
 *  \brief  Fonction de gestion des tick sur interruption timer
 *
 *  Increment tout les tick actifs
 *  \return void
 */
//------------------------------------------------------------------------------
void TICK_IT(void)
{
   // index
   unsigned char index;
   
   INTCONbits.TMR0IF = 0;          // clear (reset) flag
   TMR0H = 224;      // MSB from ADC
   TMR0L = 192;   //1ms at 32Mhz
   //TMR0H = 177;      // MSB from ADC
   //TMR0L = 227;   //10ms at 32Mhz
   //TMR0H = 126;      // MSB from ADC
   //TMR0L = 242;   //10ms at 16Mhz
   // parcour la table des tick
   for(index = 0 ; index < TICK_MAX ; index++){
      // si la valeur n'est pas nul decrement
      if( wTICK_Table[index] > 0 ) wTICK_Table[index]--;
   }
}

//------------------------------------------------------------------------------
/*! \fn    void TICK_Set(byte bId, word wValue)
 *  \brief  Mise à jour d'un tick
 *
 *  met à jour la valeur d'un tick
 *  \param bId : Id du tick a metre a jour
 *  \param wValue : Nouvelle valeur du tick
 *  \return void
 */
//------------------------------------------------------------------------------

void TICK_Set(TICK_Name_T eId, unsigned int wValue)
{
   // si le tick existe
   if(eId<TICK_MAX)
      // metre a jour la valeur
      wTICK_Table[eId]=wValue;
}

//------------------------------------------------------------------------------
/*! \fn    word TICK_Get(byte bId)
 *  \brief  lecture de la valeur d'un tick
 *
 *  \return word : renvoie la valeur du type dont l'Id est passé en argument
 */
//------------------------------------------------------------------------------
unsigned int TICK_Get(TICK_Name_T eId)
{
   // si le tick existe
   if(eId<TICK_MAX)
      return  wTICK_Table[eId];
   else return 0;
}

//------------------------------------------------------------------------------
/*! \fn    byte TICK_Is_Elapse(byte bId)
 *  \brief  Es ce que la valeur du tick est à 0
 *
 *  \param bId : Identifiant du tick 
 *  \return word : renvoie 1 si la valeur est null 0 sinon
 */
//------------------------------------------------------------------------------

Bool TICK_Is_Elapse(TICK_Name_T eId)
{
   // si le tick existe
   if(eId<TICK_MAX)
   {
      // si la valeur est null
      if(wTICK_Table[eId]==0)return true;
      else return false;
   }
	//sinon
   return false;
}

//------------------------------------------------------------------------------
/*! \fn    void TICK_Close
 *  \brief  Es ce que la valeur du tick est à 0
 *
 *  \param bId : Identifiant du tick 
 *  \return word : renvoie 1 si la valeur est null 0 sinon
 */
//------------------------------------------------------------------------------
void TICK_Close( void )
{
    unsigned char i;
    INTCONbits.TMR0IF = 0;          // clear (reset) flag
    T0CONbits.TMR0ON = 0;           // close timer
   // initialisation de tout les ticks
   for (i=0;i<TICK_MAX;i++)wTICK_Table[i]=0;
}
