Readme :


# Project BlueCom : Electronic board Software

**Last update :** 23/03/2013

This software into electronic board use a Microchip PIC18F44J100.

**See protocole Bluecom RS232 :** ![Excel Protocole](https://github.com/jcomega/BlueCom/blob/master/Project_Management/Protocole%20%20BlueCom%20RS232%20-%20Rev%20A2.xls)

#Actual functionality :

## Input and Output :

###Digital Output :
 - **DSO 0 :** Functional, used by program
 - **DSO 1 to 7 :** No configurated, must be written
 
###Digital Input :
 - No functional: must be written
 
###PWM Output:
 - **PWM_output_0 :** Functional, used by program for RGB Led projector (LED Red)
 - **PWM_output_1 :** Functional, used by program for RGB Led projector (LED Green)
 - **PWM_output_3 :** Functional, used by program for RGB Led projector (LED Blue)
 - **PWM_output 4 to 7: ** No functional: must be added in BC_pwm.c  (Ok in BlueCom.c)
 
###RGB LED projector Output :
 - **Functional, used by program :** LED Output : Red, Green, Blue + General On/OFF
	RGB LED output use PWM output : 0, 1 and 2

###Analog Output :
 - No functional: must be written
 
###Analog Input :
 - No functional: must be written
 
 ## Time and Date function :
 
 