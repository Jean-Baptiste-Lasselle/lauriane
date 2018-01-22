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
# j'ai vérifié de plus que le user linux "vyos", a les droits de faire sudo, et pour les premières commandes que j'ai faite, je n'ai pas eu à donner mdp quand je fais sudo.

############################################################
#		D'abord, l'OS installe un interface réseau		   #
#		 linux pour chaque carte réseau. Ici, j'ai moi	   #
#		"eth0", "eth1", "eth2", pour les 3 cartes réseau.  #
#		Mais si je fais ip addr je vois qu'aucune des	   #
#		interfaces n'a d'adresse ip, elle ne sont ni	   #
#		en DHCP, ni en ip statique.						   #]
#							TESTEES			   			   #
############################################################
# 1./ Donc, on commence par configurer une des interface
#	  réseau en dhcp, pour qu'elle soit connectée au
#	  réseau construit par la livebox avec le DHCP, et
#	  obtienne uen adresse IP.
############################################################
configure
set interfaces ethernet eth0 address dhcp
commit
save
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

# ======>>>>> À partir de là, on peut exécuter en SSH.


# on sort du mode édition de la configuration
exit

# affiche la version de VyOS
show version


############################################################
# 2./ On configure les adresses IP des 2 interfaces réseaux
# 	  eth1 / eth2 destinées aux 2 autres réseaux 
############################################################

# ---------------------------------------------------------
# La topologie cible
# 
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#				          	RESEAUX									| IP routeur VyOS			 |		Description Réseau
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# 		 		 réseau-1: 192.168.1.0/24		--- eth0 ----\\		| donnée en dhcp par livebox |		Le réseau sur lequel on a accès à internet via le routeur 192.168.1.1 (livebox)
# 		 		 réseau-1: 192.168.2.0/24		--- eth1 ---- \\	| 192.168.2.1				 |		Un réseau de mes VMs
# 		 		 réseau-1: 192.168.3.0/24		--- eth2 ---- //	| 192.168.3.1				 |		Un autre réseau de les VMs.
# 		 		 ------------------------		--- ---- ----//

configure
# réseau privé 1
set interfaces ethernet eth1 address 192.168.2.1/24
# set interfaces ethernet eth1 address 192.168.2.23/24
# réseau privé 2
set interface ethernet eth2 address 192.168.3.1/24
# set interface ethernet eth2 address 192.168.3.7/24
commit
save

# on sort du mode édition de la configuration
exit


# TODO ==>> la partie ci-dessous pas encore testée.
############################################################
# 3./ On donne accès internet, aux machines sur le réseau 1:
#		192.168.2.0/24  [routeur: 192.168.2.1]
############################################################
# 
# Pour cela, on va définir une règle NAT
# Tout ceci est test, et marche
# 
configure
###################################
# MAITENANT ON DEFINIT LA REGLE NAT
###################################
# 1./ on entre en mode édition d'une règle NAT
#     l'entier qui est le "numéro de règle (rule)" est libre de choix.
edit nat source rule 12 
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

# et voilà, le routeur VyOS agit comme routeur sur le réseau 192.168.2.1
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
 # - choisir une VM dans le réseau 192.168.3.0/24
 # - dans cette VM, faire un ping 8.8.8.8, pour véirifier l'accès à internet
 # - puis dans le routeur, exécuter la commande suivante affichera le log des NATs:
 show nat source translations
 # 
 
 

# à quoi sert next-hop ?
# set protocoles static route 0.0.0.0/0 next-hop 192.168.0.1

# set system domaine-name 7zunft.io
# set system host-name 7zunft-io-router1
# set system name-server 8.8.8.8
