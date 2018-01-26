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
# ¤ distributions VyOS:
# 		?
# 
# 
# ----------------------------------------------------------

# ----------------------------------------------------------
# testé pour:
# 
# 
# ----------------------------------------------------------
# (VyOS 1.1.8)
# ----------------------------------------------------------
# ¤ [TEST-OK] + moitié TEST-KO ;)
# 
# 
# ----------------------------------------------------------
# (Ubuntu)
# ----------------------------------------------------------
# 
# ¤ [TEST-KO]
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


# nomdefonctionauchoix () {



# }

# # appel de la fonction sans parenthèses
# nomdefonctionauchoix



############################################################
############################################################




############################################################
############################################################
#					exécution des opérations			   #
#							TESTEES			   			   #
# 					version: VyOS 1.1.8					   #
############################################################
############################################################


################   installation de docker tentée sur le VyOS




# configure
# set system package repository squeeze url http://ftp.jp.debian.org/debian/

 # Maintenant que Squeeze est archivée, comment puis-je obtenir des paquets de cette version ?
    # Utilisez la ligne suivante dans votre fichier sources.list :

        # deb http://archive.debian.org/debian squeeze main
        # deb http://archive.debian.org/debian squeeze-lts main

# set system package repository squeeze url http://archive.debian.org/debian
# set system package repository squeeze distribution squeeze
# set system package repository squeeze components 'main contrib non-free'
# set system package repository squeeze-lts url http://archive.debian.org/debian
# set system package repository squeeze-lts distribution squeeze-lts
# set system package repository squeeze-lts components 'main contrib non-free'

# commit
# save

################################################################################################
# Vérifiez que les deux lignes suivantes sont bien présentes dans "/etc/apt/sources.list" :
# (mais non-commentées, bien sûr...)
################################################################################################
# deb http://archive.debian.org/debian squeeze main contrib non-free # squeeze #
# deb http://archive.debian.org/debian squeeze-lts main contrib non-free # squeeze-lts #
################################################################################################

# Ces commandes ont mis  à jour les URLs des repo Debian utilisés pour les updates / upgrades.
# Je dois de plus commenter un repo configuré dans "/etc/apt/sources.list":


# Then I realized that Debian Squeeze had reached its EOL. So, to be able to install packages I have to:

# 1. Add the following line to /etc/apt/sources.list file:

# deb http://archive.debian.org/debian/ squeeze main non-free contrib

################################################################################################
# Au final, le contenu de "/etc/apt/sources.list" doit être :
################################################################################################
# # deb http://packages.vyos.net/vyos helium main # community #
# deb http://archive.debian.org/debian squeeze main contrib non-free # squeeze #
# deb http://archive.debian.org/debian squeeze-lts main contrib non-free # squeeze-lts #
################################################################################################

############ On  ajoute aussi les répos de la version vers laquelle on veut faire un dist-upgrade
# 
# ceux de Wheezy (officiel debian)
# --------------------------------
# 
# 
# deb http://deb.debian.org/debian/ wheezy main contrib non-free
# deb-src http://deb.debian.org/debian/ wheezy main contrib non-free
# 
# 
# deb http://security.debian.org/ wheezy/updates main contrib non-free
# deb-src http://security.debian.org/ wheezy/updates main contrib non-free
# 
# 
# deb http://deb.debian.org/debian/ wheezy-updates main contrib non-free
# deb-src http://deb.debian.org/debian/ wheezy-updates main contrib non-free
# 
# 


configure

# deb http://deb.debian.org/debian/ wheezy main contrib non-free
# deb-src http://deb.debian.org/debian/ wheezy main contrib non-free
# 
set system package repository wheezy url http://deb.debian.org/debian/
set system package repository wheezy distribution wheezy
set system package repository wheezy components 'main contrib non-free'


# deb http://security.debian.org/ wheezy/updates main contrib non-free
# deb-src http://security.debian.org/ wheezy/updates main contrib non-free
# => il poser problème apparrement...?
set system package repository wheezy-sec-updates url http://archive.debian.org/debian
set system package repository wheezy-sec-updates distribution wheezy/updates
set system package repository wheezy-sec-updates components 'main contrib non-free'


# deb http://deb.debian.org/debian/ wheezy-updates main contrib non-free
# deb-src http://deb.debian.org/debian/ wheezy-updates main contrib non-free
# 
set system package repository wheezy-updates url http://deb.debian.org/debian/
set system package repository wheezy-updates distribution wheezy-updates
set system package repository wheezy-updates components 'main contrib non-free'
commit
save


# ensuite, je commente la seule ligne qu'il y avait dans le fichier (le repository vyos)
# "deb http://packages.vyos.net/vyos helium main # community #"
export TRUCAREMPLCAER='deb http:\/\/packages.vyos.net\/vyos helium main # community #'
# sed -i 's/deb http:\/\/packages.vyos.net\/vyos helium main # community #/#deb http:\/\/packages.vyos.net\/vyos helium main # community #/g' /etc/apt/sources.list
sudo sed -i "s/$TRUCAREMPLCAER/#$TRUCAREMPLCAER/g" /etc/apt/sources.list


################################################################################################
# # TEST # cat  "/etc/apt/sources.list"
################################################################################################
# # et voilà ce que ça doit donner comme "/etc/apt/sources.list" final:
################################################################################################
# deb http://deb.debian.org/debian/ wheezy main contrib non-free
# deb http://security.debian.org/ wheezy/updates main contrib non-free
# deb http://deb.debian.org/debian/ wheezy-updates main contrib non-free
# 



################################################################################################
# 
# ensuite, je remplace:
# 
# 		APT::Default-Release "squeeze-lts";
# par:
# 		APT::Default-Release "wheezy";
# 
# dans le fichier "/etc/apt/apt.conf".
# -
# Mais dans VyOS 1.1.8, il n'y a pas d'occurrence de la chaîne de caractères :
#
# 			APT::Default-Release "squeeze-lts";
#
# dans le fichier "/etc/apt/apt.conf".
# -
# Donc, on fait un append de APT::Default-Release "wheezy";
# -
# 
# Enfin, dans VyOS 1.1.8, la seule ligne présente dansle fichier "" est:
# 
# 		APT::Periodic::Update-Package-Lists 1;
# 
# À ce propos, voici ce que dis la doc officielle debian: https://wiki.debian.org/UnattendedUpgrades
# 
# "
# The purpose of unattended-upgrades is to keep the computer current with the latest security (and other) updates automatically.
# If you plan to use it, you should have some means to monitor your systems, such as installing the apt-listchanges package and
# configuring it to send you emails about updates.
# And there is always /var/log/dpkg.log, or the files in /var/log/unattended-upgrades/. 
# "
# 
# Donc en fait, je décide de le commenter le temps de la procédure de dist-upgrade pusi mse à jour système.
# J'évite les at-get autoremove et autres apt-get autoclean, apt-get clean all etc...: pour abimer le moins possible les isntallations faîtes par VyOS.
# 
# 
# je commente la seule ligne présente
export TRUCAREMPLCAER2='APT::Periodic::Update-Package-Lists 1;'
sudo sed -i "s/$TRUCAREMPLCAER2/#$TRUCAREMPLCAER2/g" /etc/apt/apt.conf
# j'ajoute celle indiquée par la procédure officielle debian https://wiki.debian.org/fr/LTS/Using
# sudo echo 'APT::Default-Release "squeeze-lts";' >> /etc/apt/apt.conf
# sudo echo 'APT::Default-Release "squeeze-lts";' >> /etc/apt/apt.conf
export numeroligne=1;
sudo sed -i "$numeroligne a APT::Default-Release \"wheezy\";" /etc/apt/apt.conf

################################################################################################
# # TEST # cat  "/etc/apt/apt.conf"
################################################################################################
# le résultat ddoit exéctement être (sans les tabulations):
################################################################################################
# 			#APT::Periodic::Update-Package-Lists 1;
# 			APT::Default-Release "wheezy";
################################################################################################





# Mettez à jour votre système. apt-get update
sudo apt-get update -y 

# 
# un bugfix pour : http://gnuru.org/article/1486/debian-public-keys-error-2  qui n'était pas signalé par la doc officielle debian
# nb: il faut bel et bien faire
#
# -  un premier "apt-get update" avant cette installation,
# - puis installer ces packages,
# - puis reprendre la liste des instructions debian pour upgrade squeeze => wheezy. Donc passser à   "apt-get install -y apt -t wheezy"
#
sudo apt-get install -y  debian-keyring debian-archive-keyring


# Installez apt à partir de Wheezy avant de mettre à niveau votre système.
sudo  apt-get install -y apt -t wheezy

# Mettez à niveau votre système.
sudo apt-get upgrade -y

# Mettez à niveau votre système et supprimez les paquets obsolètes.
sudo apt-get dist-upgrade
# Vérifiez soigneusement toutes les invites de commande debconf et mettez à jour les fichiers de configuration si nécessaire. 
# ?? je fais ça comment ???

# Ok, donc à priori, ça ne marche pas :) :)




# sudo apt-get -o Acquire::Check-Valid-Until=false update -y 
# sudo apt-get -o Acquire::Check-Valid-Until=false upgrade -y 
# sudo apt-get dist-upgrade -y
# sudo apt-get -o Acquire::Check-Valid-Until=false dist-upgrade -y



# MON PLAN POUR LA SUITE était:




# Pour installer Docker télécharger l'un de *.deb suivants:
# https://download.docker.com/linux/debian/dists/wheezy/pool/stable/amd64/*.deb
# exemple : https://download.docker.com/linux/debian/dists/wheezy/pool/stable/amd64/docker-ce_17.03.0~ce-0~debian-wheezy_amd64.deb
#  - 
# export DEB_FILE_V1_NAME=docker-ce_17.03.0~ce-0~debian-wheezy_amd64.deb #  2017-03-01 11:11  27M
# export DEB_FILE_V2_NAME=docker-ce_17.03.1~ce-0~debian-wheezy_amd64.deb # 2017-03-28 04:46  27M
# export DEB_FILE_V3_NAME=docker-ce_17.03.2~ce-0~debian-wheezy_amd64.deb # 2017-06-28 03:35  27M
# export DEB_FILE_V4_NAME=docker-ce_17.06.0~ce-0~debian_amd64.deb        #       2017-06-28 05:17  28M
# export DEB_FILE_V5_NAME=docker-ce_17.06.1~ce-0~debian_amd64.deb        #       2017-08-18 02:35  29M
# export DEB_FILE_V6_NAME=docker-ce_17.06.2~ce-0~debian_amd64.deb        #       2017-09-05 10:39  29M
# export DEB_FILE_V7_NAME=docker-ce_17.09.0~ce-0~debian_amd64.deb        #       2017-09-27 01:47  29M
# export DEB_FILE_V8_NAME=docker-ce_17.09.1~ce-0~debian_amd64.deb        #      2017-12-08 12:22  29M
# export DEB_FILE_V9_NAME=docker-ce_17.12.0~ce-0~debian_amd64.deb        #       2017-12-27 09:52  42M



# export BASE_DWNLD_URL=https://download.docker.com/linux/debian/dists/wheezy/pool/stable/amd64/
# DEB_FILE_VERSION_TO_INSTALL=$DEB_FILE_V1_NAME
# DEB_FILE_VERSION_TO_INSTALL=$DEB_FILE_V2_NAME
# DEB_FILE_VERSION_TO_INSTALL=$DEB_FILE_V3_NAME
# export DEB_FILE_VERSION_TO_INSTALL;
# curl $BASE_DWNLD_URL/$DEB_FILE_VERSION_TO_INSTALL >> ./$DEB_FILE_VERSION_TO_INSTALL

# puis j'installe le deb local:

# sudo chmod +x ./$DEB_FILE_VERSION_TO_INSTALL
# sudo dpkg -i ./$DEB_FILE_VERSION_TO_INSTALL



# curl -sSL https://get.docker.com/ | /bin/sh
# curl -sSL https://get.docker.com/ | /bin/bash
# sudo usermod -aG docker vyos
# logout and login
# sudo sed -i '/--no-close/d' /etc/init.d/docker
# sudo /etc/init.d/docker start





# Selon la doc docker officielle:
# 
# "
# Wheezy only: The version of add-apt-repository on Wheezy adds a deb-src repository that does not exist.
# You need to comment out this repository or running apt-get update will fail.
# Edit /etc/apt/sources.list. Find the line like the following, and comment it out or remove it:
# "
# 
# Là je serais censé commenter la ligne "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
# dans le fichier "/etc/apt/sources.list" (mais ils disent "Wheezy only"... Et VyOS est sous Debian Squeeze, qui plus vieille que Wheezy, mais différente)

# echo "éditez le le fichier \"/etc/apt/sources.list\", en commentant simplement la ligne: "
# echo "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
# echo "puis pressez la touche Entrée pour continuer"
# read

# sudo apt-get update -y
# sudo apt-get install -y docker-ce

# clear
# echo "Fin Install Docker "
# read












# Pour les tests, ils peuvent se faire avec des machines Ubuntu

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
