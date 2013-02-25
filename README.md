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
–	**What version of android is compatible? ?** The programme works starting from android 2.2
-	**The documentation is in English.**
-	**The communication protocol is designed so that the receiver box can be evolved:** additions of new features.

-------------------------------------
##French presentation :

###Le projet BlueCom est composé de plusieurs éléments :
Un boîtier récepteur pouvant commander plusieurs appareils secteur (Lampe, moteur, autres)
Un appareil sous android avec le logiciel de communication pour communiquer avec le boîtier récepteur. (Un téléphone par exemple)

Chaque boîtier récepteur peut être télécommandé de façon intelligente à l'aide d'un appareil sous Android en Bluetooth. (Téléphone, tablette, média player, etc).
Ce projet est open-source, il sera évolutif : mesure température, multi entrées et sorties, compatible avec système existant (porte de garage).

![Synoptic Picture](https://raw.github.com/jcomega/BlueCom/master/Project_Management/Presentation_Rev1.jpg)


###Fonctionnement :
Sur le récepteur l'utilisateur branche un appareil secteur à commander : une lampe par exemple.
Sur le téléphone, on lance l’application « BlueCom » qui se connecte automatiquement au récepteur.
Sur le téléphone, le statut du récepteur est affiché en temps réel. (Si la lampe est déjà allumé : le bouton dans l'application du téléphone change d'état).
L'application sur le téléphone peut programmer des plages horaires de fonctionnement ou de déclenchement automatique. Les informations déjà présentes dans le récepteur sont affichées sur le téléphone. (Le récepteur est automatiquement mis à l'heure)





###Le dossier le projet est composé de plusieurs sous-dossiers :
-	**BlueCom_Android_Application** : Dossier contenant les sources et release pour l’application android (.apk)
-	**BlueCom_Electronic_Board_Hardware** : Schéma et PCB de la carte électronique (Eagle files).
-	**BlueCom_Electronic_Board_Software** : Dossier contenant les sources et release pour le microcontrôleur (Microchip PIC).
-	**Project_Management** : Information pour le projet (nomenclature, images, communication, synoptique)

###FAQ :
–	**Quel version d'android est compatible ?** Le programme java fonctionne à partir d'android 2.2
-	**La documentation est en anglais.**
-	**Le protocole de communication est conçus pour que le boitier récepteur soit évolutif :** ajouts de nouvelles fonctions.

