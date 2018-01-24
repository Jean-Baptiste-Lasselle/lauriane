#!/bin/bash

############################################################
############################################################
############################################################
############################################################
############################################################
# 					PROVISIONNING ROUTEUR 		 		   #
# 				   RESEAU USINE LOGICIELLE		 		   #
############################################################
############################################################
############################################################
############################################################
############################################################
############################################################




############################################################
############################################################
# 					Compatibilité système		 		   #
############################################################
############################################################

# ----------------------------------------------------------
# [Pour Comparer votre version d'OS à
#  celles mentionnées ci-dessous]
# 
# ¤ distributions Ubuntu:
#		lsb_release -a
#
# ¤ distributions CentOS:
# 		cat /etc/redhat-release
# 
# 
# ----------------------------------------------------------

# ----------------------------------------------------------
# testé pour:
# 
# 
# 
# 
# ----------------------------------------------------------
# (Ubuntu)
# ----------------------------------------------------------
# 
# ¤ [TEST-OK]
#
# 	[Distribution ID: 	Ubuntu]
# 	[Description: 		Ubuntu 16.04 LTS]
# 	[Release: 			16.04]
# 	[codename:			xenial]
# 
# 
# 
# 
# 
# 
# ----------------------------------------------------------
# (CentOS)
# ----------------------------------------------------------
# 
# 
# 
# ...
# ----------------------------------------------------------

############################################################
############################################################
#							ENV.						   #
############################################################
############################################################

############################################################
############################################################
#				déclarations des fonctions				   #
############################################################
############################################################


# ---------------------------------------------------------
# [description]
# ---------------------------------------------------------
# Cette fonction permet de ...........
# 
# Afin de décider quel interface réseau linux sera
# utilisé, cette fonction procède de la manière suivante:
# 
#  - si aucun ..........
#  - si aucun ..........
#  - si aucun ..........
#  - si aucun ..........
# ---------------------------------------------------------
# [signature]
# ---------------------------------------------------------
#
# 	$1 => le .........
#
# ---------------------------------------------------------


nomdefonctionauchoix () {



}

# # appel de la fonction sans parenthèses
# nomdefonctionauchoix

############################################################
############################################################
# La topologie réseau cible
############################################################
############################################################
# 
# Cette recette s'applique pour une VM ayant:
# 4 cartes réseaux:
#
# - une en mode "Accès par pont": elle sera ainsi connectée au réseau physique dans lequel se trouve la livebox, chez moi (la livebox contient un serveur DHCP, en plus de jouer le rôle de routeur)
# - une en mode "Internal Network": et le nom du réseau interne VirtualBox, sera: "RESEAU_USINE_LOGICIELLE" // routeur R1, cette VM
# - une en mode "Internal Network": et le nom du réseau interne VirtualBox, sera: "RESEAU_CIBLE_DEPLOIEMENT" // sera en dhcp dans ce réseau, avec le routeur R2
# - une en mode "Internal Network": et le nom du réseau interne VirtualBox, sera: "RESEAU_MACHINES_PHYSIQUES"// sera en dhcp dans ce réseau, avec le routeur R3
# 
# Une fois un OS VyOS installé et configuré, cette VM sera le routeur du "RESEAU_USINE_LOGICIELLE".
# 
# 
# == >> Utliser 3 "Internal network" virtual box, + un accès par pont à un 4 ième réseau, revient à se trouver dans la situation de 4 réseaux PHYSIQUEMENT déconnectés.
# 
#		 ¤ avec le routeur R2 dans le réseau "RESEAU_CIBLE_DEPLOIEMENT"
#		 ¤ avec le routeur R3 dans le réseau "RESEAU_MACHINES_PHYSIQUES"
# 
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 4 cartes réseau au lieu de 3.
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# réseau                              |                net id + netmask                             |         interfaces réseau linux
# ------------------------------------------------------------------------------------------------------------------------------------------------------------
# RESEAU_EXTERIEUR                    |                 192.168.1.0/24   (réseau de la livebox)     |       eth0       Le réseau via lequel on a accès à internet.
# RESEAU_USINE_LOGICIELLE             |                 192.168.2.0/24                              |       eth1       Le réseau de l'usine logicielle
# RESEAU_CIBLE_DEPLOIEMENT	          |                 192.168.3.0/24                              |       eth2	   Le réseau de la cible de déploiement
# RESEAU_MACHINES_PHYSIQUES	          |                 192.168.4.0/24                              |       eth3       Le réseau des machines physiques, auquel les VM ne doivent pas avoir accès.
# ------------------------------------------------------------------------------------------------------------------------------------------------------------
# Nota Bene: [1 conteneur Web Jee] =>>> pour la gestion de la publication de la documentation (dans un site web projet interne) et autres publications vers
#                                       l'extérieur comme les réseaux sociaux.
# ------------------------------------------------------------------------------------------------------------------------------------------------------------

# **** Le réseau de l'usine logicielle: 
#
# --- Sur pc de dev 16 Gb RAM:
# - 1 [6 Gb RAM, 2 vCPUs] VM pour l'ide Eclipse,
# - 1 [8 Gb RAM, 2 vCPUs] VM pour 1 conteneur Artifactory, 1 conteneur gitlab,

# --- Sur serveur 50Gb RAM: (4 coeurs Xeon)
# - 1 [8 Gb RAM, 2 vCPUs] VM pour 1 autre conteneur gitlab, 1 conteneur Web Jee,
# - 1 [8 Gb RAM, 2 vCPUs] VM pour 1 autre conteneur Jenkins,
# 
# 

# **** Le réseau de la cible de déploiement: 
# 
# --- Sur serveur 50Gb RAM: (4 coeurs Xeon)
# - N * 3  VM [10 Gb RAM, 2 vCPUs] pour y jardiner des conteneurs dockers, des services kubernetes, ou des appliances openstack multi-tenant



# **** Le total des VMS sur serveur
# 4 coeurs Xeon, Redhat conseille moins de 10 vCPUs par coeur réel, et sur le serveur on est à 4 coeurs réels Xeon, avec 10 vCPUs créés en tout.
# On peut, au départ, réduire la taille de l'usine logicielle en la limitant à un des 2 VMs contennant un gitlab, et la VM IDE contenant
# eclipse, ce qui fait 14 Gà en tout. Il faut alors au moins 8 Go de RAM supplémentaire pour pouvoir monter une cible d déploiement un minimum utile.
# On va donc dire que notre environnement ocmmence à être productif 22 Go de VM utilisables.


# **** Le réseau des machines physiques: 
# 
# le réseau dans lequel je mets toutes les machiens que je veux particulièrement protéger, comme mes serveurs.
# C'est dans ce réseau qu'ils sont provisionnnés en pixie


# Ceci étant, dans ce cas d'utilisation d'un routeur par réseau, j'utilise 3 VMs rien
# que pour les routeurs, donc il est à voir comment faire plus efficace pour segmenter
# les réseaux, ou alors voir s'il ne serait possible de proposer plusieurs
# installations, comme il y a un minikube pour kubernetes k8s.
# Exemple: faire 2 installateurs :

#    Formule utltra compacte (tiens dans un PC 16 Gb de RAM): installe la cible de déploiement minimale en une VM de 4Gb RAM, le eclipse dans une VM de 6Gb de RAM, et un gitlab et un artifactory dans une VM de 4 Gb
#    Formule Juza des nuages (en tout, au moins 2 machines physiques, laptop MAC 8 Gb de RAM et desktop 32 Gb  de RAM, 8 vCPUs consommés): installe la cible de déploiement en une VM de 16Gb RAM, 4 vCPUs (avec Kubernetes dedans), le eclipse dans une VM de 6Gb de RAM (2 vCPUs), et un gitlab et un artifactory dans une VM de 8 Gb (2 vCPUS), un autre gitlab et un Jenkins dans une VM de 8 Gb de RAM
#    Formule Toki (en tout, au moins 2 machines physiques, et 64 Gb de RAM, 12 vCPUs consommés): installe la cible de déploiement en une VM de 16Gb RAM, 4 vCPUs (avec Kubernetes dedans), le eclipse dans une VM de 6Gb de RAM (2 vCPUs), et un gitlab et un artifactory dans une VM de 8 Gb (2 vCPUs), 3 autres Gitlabs dans une VM de 16 Gb et un Jenkins dans une VM de 16Gb de RAM (4 vCPUs)



############################################################
############################################################




############################################################
############################################################
#					exécution des opérations			   #
#							TESTEES			   			   #
# 						version: 1.1.8					   #
############################################################
############################################################

# 0./ installation de vyos (je vérifie s'il y a un
#     kickstart file généré à l'installation: non, mais
#     j'ai trouvé https://github.com/AdrianKoshka/AIS )
# 
# Il faut exécuter la commande "install image", et suivre
# le reste. ensuite, commande "reboot", pour rebooter, le
# disque n'est pas éjecté, mais le boot se fait par le
# disque correctement.
# 
# version: 1.1.8
# j'ai vérifié de plus que le user linux "vyos", a les
# droits de faire sudo, et pour les premières commandes
# que j'ai faite, je n'ai pas eu à donner mdp quand je
# fais sudo.

############################################################
#		D'abord, l'OS installe un interface réseau		   #
#		 linux pour chaque carte réseau. Ici, j'ai moi	   #
#		"eth0", "eth1", "eth2", pour les 3 cartes réseau.  #
#		Mais si je fais ip addr je vois qu'aucune des	   #
#		interfaces n'a d'adresse ip, elle ne sont ni	   #
#		en DHCP, ni en ip statique.						   #]
#							TESTEES			   			   #
############################################################
# 1./ Donc, on commence par apliquer une configuration IP
#	  aux les 4 interface réseau linux du routeur.
#
#     eth0 sera connectée au réseau dont le routeur
#     est le routeur FAI (ISP's router)
#     et obtiendra une adresse IP de la livebox par DHCP.
############################################################
configure
# réseau RESEAU_EXTERIEUR  => en dhcp, car le routeur du réseau RESEAU_EXTERIEUR n'est pas ce routeur, mais le routeur de votre FAI ("ISP's router"), le plus souvent d'adresse IP interne 192.168.1.1/24 sur le réseau RESEAU_EXTERIEUR.
set interfaces ethernet eth0 address dhcp
# réseau RESEAU_USINE_LOGICIELLE  => en IP statique, car ce routeur est le routeur du réseau RESEAU_USINE_LOGICIELLE
set interfaces ethernet eth1 address 192.168.2.1/24
# réseau RESEAU_CIBLE_DEPLOIEMENT  => en DHCP, car le routeur du réseau RESEAU_CIBLE_DEPLOIEMENT n'est pas ce routeur, mais le routeur R2, d'adresse IP 192.168.3.17/24 sur le réseau RESEAU_CIBLE_DEPLOIEMENT.
set interface ethernet eth2 address dhcp
# réseau RESEAU_CIBLE_DEPLOIEMENT  => en DHCP, car le routeur du réseau RESEAU_MACHINES_PHYSIQUES n'est pas ce routeur, mais le routeur R3, d'adresse IP 192.168.4.1/24 sur le réseau RESEAU_MACHINES_PHYSIQUES.
set interface ethernet eth3 address dhcp
commit
save
exit
# on vérifies l'adresse IP avec ip addr

############################################################
# 2./ On active le service SSH.
#     À noter, j'ai véirifé, ssh-keygen -t rsa -b 4096 est
#	  possible directement, aucune installation de
#	  ssh-keygen à faire.
############################################################
configure
set service ssh port 22
commit
save
exit

# ======>>>>> À partir de là, on peut exécuter en SSH, étant donnée que est connectée et a obtenu une adresse IP, en dhcp, du routeur du FAI.




# affiche la version de VyOS
show version



# TODO ==>> la partie ci-dessous pas encore testée.
############################################################
# 2./ On configure 3 règles, pour que les machines du
#     réseau "RESEAU_USINE_LOGICIELLE", ait accès aux
#      machines sur les réseaux: 
#         ¤ internet, via RESEAU_EXTERIEUR (le routeur de votre FAI, "ISP's router", est le routeur de ce réseau)
#         ¤ RESEAU_CIBLE_DEPLOIEMENT
#         ¤ RESEAU_MACHINES_PHYSIQUES
############################################################
# 
# Pour cela, on va définir une règle NAT
# Tout ceci est test, et marche
# 
configure
###################################
# REGLE NAT: RESEAU_USINE_LOGICIELLE ==>> RESEAU_EXTERIEUR  (et internet, le routeur ISP étant configuré lui aussi avec une règle NAT masquerade).
###################################
# 1./ on entre en mode édition d'une règle NAT
#     l'entier qui est le "numéro de règle (rule)" est libre de choix.
edit nat source rule 7 
# 2./ on définit l'interface "OUTBOUND" ==>> donc pour
#     nous "DEHORS", c-a-d 192.168.1.0/24, soit [eth0]
set outbound-interface eth0
# 3./ on définit quelles adresses auront accès à l'interface
#     "OUTBOUND" (définit juste avant)
#     ici, je spécifie un réseau entier, mais il est possible
#     de spécifier d'autres manières, comme "tout sauf ce range
#     d'adresses".
#     ici, on donne donc accès à l'interface "OUTBOUND", à
#     toutes les VMs dans le réseau 192.168.2.0/24
set source address 192.168.2.0/24
# 4./ maintenant on définit la manière dont la
#   "translation" (traduction) d'adresses se fait
set translation address masquerade

commit
save
exit


configure
###################################
# REGLE NAT: RESEAU_USINE_LOGICIELLE ==>> RESEAU_CIBLE_DEPLOIEMENT
###################################
# 1./ on entre en mode édition d'une règle NAT
#     l'entier qui est le "numéro de règle (rule)" est libre de choix.
edit nat source rule 8
# 2./ on définit l'interface "OUTBOUND" ==>> donc pour
#     nous "DEHORS", c-a-d 192.168.3.0/24, soit [eth2]
set outbound-interface eth2
# 3./ on définit quelles adresses auront accès à l'interface
#     "OUTBOUND" (définit juste avant)
#     ici, je spécifie un réseau entier, mais il est possible
#     de spécifier d'autres manières, comme "tout sauf ce range
#     d'adresses".
#     ici, on donne donc accès à l'interface "OUTBOUND", à
#     toutes les VMs dans le réseau 192.168.2.0/24
set source address 192.168.2.0/24
# 4./ maintenant on définit la manière dont la
#   "translation" (traduction) d'adresses se fait
set translation address masquerade

commit
save
exit


configure
###################################
# REGLE NAT: RESEAU_USINE_LOGICIELLE ==>> RESEAU_MACHINES_PHYSIQUES
###################################
# 1./ on entre en mode édition d'une règle NAT
#     l'entier qui est le "numéro de règle (rule)" est libre de choix.
edit nat source rule 9
# 2./ on définit l'interface "OUTBOUND" ==>> donc pour
#     nous "DEHORS", c-a-d 192.168.4.0/24, soit [eth2]
set outbound-interface eth3
# 3./ on définit quelles adresses auront accès à l'interface
#     "OUTBOUND" (définit juste avant)
#     ici, je spécifie un réseau entier, mais il est possible
#     de spécifier d'autres manières, comme "tout sauf ce range
#     d'adresses".
#     ici, on donne donc accès à l'interface "OUTBOUND", à
#     toutes les VMs dans le réseau 192.168.2.0/24
set source address 192.168.2.0/24
# 4./ maintenant on définit la manière dont la
#   "translation" (traduction) d'adresses se fait
set translation address masquerade

commit
save
exit

# et voilà, le routeur VyOS agit comme routeur sur le réseau {RESEAU_USINE_LOGICIELLE|192.168.2.0/24}, à l'adresse 192.168.2.1

# et les VMs crées dans ce réseau {RESEAU_USINE_LOGICIELLE-192.168.2.0/24}, ont accès à toute VM créée dans chacun des autres réseaux.


# TODO suite/test: configurer les routeurs R1, R2, et R3, pour qu'ils attribuent des adresses IP en DHCP, en activant le
# service DHCP pour les interfces réseaux en IP fixe (eth1, pour R1, eth2, pour  R2, eth3, pour R3)


#
# Il suffit de créer 2 Vms dans ce réseau 192.168.2.0/24, pour voir
# si elles ont accès l'une à l'autre (ping)
# Disons 2 Vms Ubuntu de config à ajouter dans [/etc/network/interfaces]  :
# -------------------------------------------------------------------------
# VM1:
# auto enp0s3
# iface enp0s3 inet static
#      address  192.168.2.37
#      netmask  255.255.255.0
#      gateway  192.168.2.1
# -------------------------------------------------------------------------
# VM2:
# auto enp0s3
# iface enp0s3 inet static
#      address  192.168.2.84
#      netmask  255.255.255.0
#      gateway  192.168.2.1
# -------------------------------------------------------------------------
 # pour tester cela:
 # - choisir une VM dans le réseau 192.168.2.0/24
 # - dans cette VM, faire un ping 8.8.8.8, pour vérifier l'accès à internet
 # - puis dans le routeur, exécuter la commande suivante affichera le log des NATs:
 show nat source translations
 # 
 
 

# à quoi sert next-hop ?
# set protocoles static route 0.0.0.0/0 next-hop 192.168.0.1

# set system domaine-name 7zunft.io
# set system host-name 7zunft-io-router1
# set system name-server 8.8.8.8


############################################################
############################################################
# ANNEXE: La topologie réseau
############################################################
############################################################
# 
# Cette recette s'applique pour une VM ayant:
# 4 cartes réseaux:
# - une en mode "Accès par pont": elle sera ainsi connectée au réseau physique dans lequel se trouve la livebox, chez moi (la livebox contient un serveur DHCP, en plus de jouer le rôle de routeur)
# - une en mode "Internal Network": et le nom du réseau interne VirtualBox, sera: "RESEAU_USINE_LOGICIELLE" // routeur R1, cette VM
# - une en mode "Internal Network": et le nom du réseau interne VirtualBox, sera: "RESEAU_CIBLE_DEPLOIEMENT" // sera en dhcp dans ce réseau, avec le routeur R2
# - une en mode "Internal Network": et le nom du réseau interne VirtualBox, sera: "RESEAU_MACHINES_PHYSIQUES"// sera en dhcp dans ce réseau, avec le routeur R3
# Une fois un OS installé et configuré, cette VM sera le routeur du "RESEAU_USINE_LOGICIELLE", qui sera connecté en dhcp dans les autres réseaux:
# 
# 
# == >> Utliser 3 "Internal netwwork" virtual box, + un accès par pont à un 4 ième réseau, revient à se trouver dans la situation de 4 réseau PHYSIQUEMENT séparés.
# 
#		 ¤ avec le routeur R2 dans le réseau "RESEAU_CIBLE_DEPLOIEMENT"
#		 ¤ avec le routeur R3 dans le réseau "RESEAU_MACHINES_PHYSIQUES"
# Ceci étant, dans ce cas d'utilisation d'un routeur par réseau, j'utilise 3 VMs rien que pour les routeurs, donc il est à voir comment
# faire plus efficace pour segmenter les réseaux, ou alors voir s'il ne serait pas suffisant au déaprt, de faire des versions où l'on est surtout coupé d'internet, et on gère derrière...
# 
# 
# 
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 4 cartes réseau au lieu de 3.
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# "Internal Network" VirtualBox       |                net id + netmask                             |         interfaces réseau linux
# ------------------------------------------------------------------------------------------------------------------------------------------------------------
# RESEAU_EXTERIEUR                    |                 192.168.1.0/24   (réseau de la livebox)     |       eth0       Le réseau via lequel on a accès à internet.
# RESEAU_USINE_LOGICIELLE             |                 192.168.2.0/24                              |       eth1       Le réseau de l'usine logicielle
# RESEAU_CIBLE_DEPLOIEMENT	          |                 192.168.3.0/24                              |       eth2	   Le réseau de la cible de déploiement
# RESEAU_MACHINES_PHYSIQUES	          |                 192.168.4.0/24                              |       eth3       Le réseau des machines physiques, auquel les VM ne doivent pas avoir accès.
# ------------------------------------------------------------------------------------------------------------------------------------------------------------
# Nota Bene: [1 conteneur Web Jee] =>>> pour la gestion de la publication de la documentation (dans un site web projet interne) et autres publications vers
#                                       l'extérieur comme les réseaux sociaux.
# ------------------------------------------------------------------------------------------------------------------------------------------------------------

# **** Le réseau de l'usine logicielle: 
#
# --- Sur pc de dev 16 Gb RAM:
# - 1 [6 Gb RAM, 2 vCPUs] VM pour l'ide Eclipse,
# - 1 [8 Gb RAM, 2 vCPUs] VM pour 1 conteneur Artifactory, 1 conteneur gitlab,

# --- Sur serveur 50Gb RAM: (4 coeurs Xeon)
# - 1 [8 Gb RAM, 2 vCPUs] VM pour 1 autre conteneur gitlab, 1 conteneur Web Jee,
# - 1 [8 Gb RAM, 2 vCPUs] VM pour 1 autre conteneur Jenkins,
# 
# 

# **** Le réseau de la cible de déploiement: 
# 
# --- Sur serveur 50Gb RAM: (4 coeurs Xeon)
# - N * 3  VM [10 Gb RAM, 2 vCPUs] pour y jardiner des conteneurs dockers, des services kubernetes, ou des appliances openstack multi-tenant



# **** Le total des VMS sur serveur
# 4 coeurs Xeon, Redhat conseille moins de 10 vCPUs par coeur réel, et sur le serveur on est à 4 coeurs réels Xeon, avec 10 vCPUs créés en tout.
# On peut, au départ, réduire la taille de l'usine logicielle en la limitant à un des 2 VMs contennant un gitlab, et la VM IDE contenant
# eclipse, ce qui fait 14 Gà en tout. Il faut alors au moins 8 Go de RAM supplémentaire pour pouvoir monter une cible d déploiement un minimum utile.
# On va donc dire que notre environnement ocmmence à être productif 22 Go de VM utilisables.


# **** Le réseau des machines physiques: 
# 
# le réseau dans lequel je mets toutes les machiens que je veux particulièrement protéger, comme mes serveurs.
# C'est dans ce réseau qu'ils sont provisionnnés en pixie

############################################################
############################################################
