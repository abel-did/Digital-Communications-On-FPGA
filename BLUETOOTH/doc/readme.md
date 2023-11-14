Configuration des modules BT2


doc Roving
p.71 : command quick reference guide


LD1 (green, p. 49)
----
blink  1 Hz  : waiting for connection
blink 10 Hz  : command mode
on           : connected to another bluetooth device



Pour avoir des infos sur un module 
----------------------------------
$$$
	-> pour passer en mode commande
	réponse :CMD
	
GB (retour à ligne)
	-> permet de connaitre l'adresse du BT2
	
D (retour à la ligne)
	-> Basic Settings

E (retour à la ligne) 
	-> Extended Settings
	
----------------------------------------------------
										configuration
----------------------------------------------------	

Pour configurer un module en esclave (mode automatique)
------------------------------------
$$$
	-> pour passer en mode commande
	réponse : CMD
	
GB (retour à ligne)
	-> permet de connaitre l'adresse du BT2
	réponse (exemple) : 000666646459
	à noter pour si on veut que le maitre reconnaisse automatiquement l'esclave
	
SN,	nom_esclave (retour à ligne)
	-> permet de donner un nom au module (optionnel mais pratique)

(Par défaut le module est en mode "auto connect DTR mode" : SM,4 ; et ça marche)


SA,0 (retour à ligne)
	-> désactive l'authentification 
	réponse : AOK

R,1 (retour à ligne)
	-> reboot
	

Pour configurer un module en maitre (mode automatique)
-------------------------------------------------------
$$$
	-> pour passer en mode commande
	réponse : CMD
	
GB (retour à ligne)
	-> permet de connaitre l'adresse du BT2
	-> pas obligatoire pour le maitre
	
SN,	nom_maitre (retour à ligne)
	-> permet de donner un nom au module (optionnel mais pratique)
	réponse : AOK

SM,	3 (retour à la ligne)
	-> permet de passer en mode maitre avec apparaige automatique
	réponse : AOK

SR, 000666646459 (retour à la ligne)
	-> spécifie l'adresse de l'esclave
	réponse : AOK

SA,0 (retour à ligne)
	-> désactive l'authentification 
	réponse : AOK

R,1 (retour à ligne)
	-> reboot			