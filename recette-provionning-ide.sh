#!/bin/bash
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


determiner_un () {



}






############################################################
############################################################
#					exécution des opérations			   #
#							TESTEES			   			   #
# 						version: 1.1.8					   #
############################################################
############################################################
# 
# 
# Une VM:
# 	
# 	¤ avec 1 carte réseau en mode "réseau interne" ("Internal Networking"), avec le réseau interne VirtualBox "RESEAU_USINE_LOGICIELLE"
# 	¤ 2 CPUs
# 	¤ 6144 Mo de RAM (6 Go)
# 	¤ 1 disque dur de 80 Go
# 
# ==>> installation de Ubuntu, puis exécution des
#      opérations après un git clone (donc le noeud usine
#      logicielle gitlab doit être existant à cet instant
#      du déroulement des opérations)

# installation d'eclipse















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

