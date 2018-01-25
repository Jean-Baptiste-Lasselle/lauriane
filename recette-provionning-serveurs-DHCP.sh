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


############################################################
############################################################
# 
# 
# ¤ Pré-requis à provisionner au nivea VM:
# 
#   + Trois cartes réseaux virtuelles, une pour chacun des
#     trois "Internal Networks" virtualBox:
# 
# 				 RESEAU_USINE_LOGICIELLE
# 				 RESEAU_CIBLE_DEPLOIEMENT
# 				 RESEAU_MACHINES_PHYSIQUES
#   
#   + Deux vCPUs
#   + 2048 Mo de RAM
# 
# 
# ----------------------------------------------------------
# Donc:  Ce script permet d'installer 3 conteneurs dans
#        cette VM, et chacun ne fait usage que d'un
#        interface réseau linux, grâce à
#        l'option docker run --ip
# 
#        Dans chacun de ces 3 conteneurs, un serveur DHCP
#        Et donc, un serveur dHCP par réseau physique
#        (virtuellement physique...)
# 
# 
############################################################
############################################################

############################################################
############################################################
#						ENVIRONNEMENT					   #
############################################################
ADRESSE_IP_INTERFACE_RESEAU_USINE_LOGICIELLE=192.168.2.3
ADRESSE_IP_INTERFACE_RESEAU_CIBLE_DEPLOIEMENT=192.168.3.4
ADRESSE_IP_INTERFACE_RESEAU_MACHINES_PHYSISQUES=192.168.4.5

NOM_IMAGE_DOCKER_ZUNFT_DHCP_SERVER=7zunft.io/dhcpserver
VERSION_IMAGE_DOCKER_ZUNFT_DHCP_SERVER=v1.0

NOM_CONTENEUR_SRV_DHCP_USINE_LOGICIELLE=srv-dhcp-reseau-usine-logicielle
NOM_CONTENEUR_SRV_DHCP_CIBLE_DEPLOIEMENT=srv-dhcp-reseau-cible-deploiement
NOM_CONTENEUR_SRV_DHCP_MACHINES_PHYSISQUES=srv-dhcp-reseau-machines-physiques




############################################################
############################################################
#					exécution des opérations			   #
#							TESTEES			   			   #
# 						version: 1.1.8					   #
############################################################
############################################################


# TODO: ajouter la création le dockerfile de l'image docker "isc-dhcp-server" que je veux, comme je la veux.
# TODO: ajouter le build de l'image docker 7zunft.io/dhcpserver:v1.0 / $NOM_IMAGE_DOCKER_ZUNFT_DHCP_SERVER:$VERSION_IMAGE_DOCKER_ZUNFT_DHCP_SERVER

# opérations 
sudod docker run --name $NOM_CONTENEUR_SRV_DHCP_USINE_LOGICIELLE --ip=$ADRESSE_IP_INTERFACE_RESEAU_USINE_LOGICIELLE  -d $NOM_IMAGE_DOCKER_ZUNFT_DHCP_SERVER:$VERSION_IMAGE_DOCKER_ZUNFT_DHCP_SERVER
sudod docker run --name $NOM_CONTENEUR_SRV_DHCP_CIBLE_DEPLOIEMENT --ip=$ADRESSE_IP_INTERFACE_RESEAU_CIBLE_DEPLOIEMENT  -d $NOM_IMAGE_DOCKER_ZUNFT_DHCP_SERVER:$VERSION_IMAGE_DOCKER_ZUNFT_DHCP_SERVER
sudod docker run --name $NOM_CONTENEUR_SRV_DHCP_MACHINES_PHYSISQUES --ip=$ADRESSE_IP_INTERFACE_RESEAU_MACHINES_PHYSISQUES  -d $NOM_IMAGE_DOCKER_ZUNFT_DHCP_SERVER:$VERSION_IMAGE_DOCKER_ZUNFT_DHCP_SERVER













# ################## TESTS #################################




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
 # - dans cette VM, faire ....
 # - puis dans le routeur, exécuter ... 
 


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
