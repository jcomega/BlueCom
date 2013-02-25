Readme :


# Project BlueCom.

**This document is in French and English.**


-------------------------------------
##English presentation :

###The BlueCom project is composed of several elements:
A receiver box can control multiple devices sector (lamp, motor, etc.).
A Android device with the communication software to communicate with the receiver box. (for example: a mobile phone).

Each receiver box can be remotely intelligently using an Android device via Bluetooth. (Phone, tablet, media player, etc).
This project is open source, it could be modified: temperature function, multiple inputs and outputs, compatible with the existing system.

![Synoptic Picture](https://raw.github.com/jcomega/BlueCom/master/Project_Management/Presentation_Rev1.jpg)


###Mode of operation:
On the receiver the user plugs a device who must be controlled: a lamp for example.
On the phone, the user launch the application "Bluecom" that automatically connects to the receiver.
On the phone, the receiver status is displayed in real time. (If the lamp is already switch on: this status is displaying into application).
The application on the phone can set operating time ranges or automatic trigger. Informations contents in the receiver are displayed on the phone. (The receiver is automatically set to the current hour)

###The project folder is composed of several sub-folders:
-	**BlueCom_Android_Application** : Folder containing the sources and release for android app (. Apk).
-	**BlueCom_Electronic_Board_Hardware** : Drawing and PCB for the electronic board (Eagle files).
-	**BlueCom_Electronic_Board_Software** : Folder containing the sources and release for the microcontroler.(Microchip PIC).
-	**Project_Management** : Information for the project (nomenclature, pictures, communication, synoptic)

###FAQ :
�	**What version of android is compatible? ?** The programme works starting from android 2.2
-	**The documentation is in English.**
-	**The communication protocol is designed so that the receiver box can be evolved:** additions of new features.

-------------------------------------
##French presentation :

###Le projet BlueCom est compos� de plusieurs �l�ments :
Un bo�tier r�cepteur pouvant commander plusieurs appareils secteur (Lampe, moteur, autres)
Un appareil sous android avec le logiciel de communication pour communiquer avec le bo�tier r�cepteur. (Un t�l�phone par exemple)

Chaque bo�tier r�cepteur peut �tre t�l�command� de fa�on intelligente � l'aide d'un appareil sous Android en Bluetooth. (T�l�phone, tablette, m�dia player, etc).
Ce projet est open-source, il sera �volutif : mesure temp�rature, multi entr�es et sorties, compatible avec syst�me existant (porte de garage).

![Synoptic Picture](https://raw.github.com/jcomega/BlueCom/master/Project_Management/Presentation_Rev1.jpg)


###Fonctionnement :
Sur le r�cepteur l'utilisateur branche un appareil secteur � commander : une lampe par exemple.
Sur le t�l�phone, on lance l�application � BlueCom � qui se connecte automatiquement au r�cepteur.
Sur le t�l�phone, le statut du r�cepteur est affich� en temps r�el. (Si la lampe est d�j� allum� : le bouton dans l'application du t�l�phone change d'�tat).
L'application sur le t�l�phone peut programmer des plages horaires de fonctionnement ou de d�clenchement automatique. Les informations d�j� pr�sentes dans le r�cepteur sont affich�es sur le t�l�phone. (Le r�cepteur est automatiquement mis � l'heure)





###Le dossier le projet est compos� de plusieurs sous-dossiers :
-	**BlueCom_Android_Application** : Dossier contenant les sources et release pour l�application android (.apk)
-	**BlueCom_Electronic_Board_Hardware** : Sch�ma et PCB de la carte �lectronique (Eagle files).
-	**BlueCom_Electronic_Board_Software** : Dossier contenant les sources et release pour le microcontr�leur (Microchip PIC).
-	**Project_Management** : Information pour le projet (nomenclature, images, communication, synoptique)

###FAQ :
�	**Quel version d'android est compatible ?** Le programme java fonctionne � partir d'android 2.2
-	**La documentation est en anglais.**
-	**Le protocole de communication est con�us pour que le boitier r�cepteur soit �volutif :** ajouts de nouvelles fonctions.

