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
# ----------------------------------------------------------
# (Ubuntu)
# ----------------------------------------------------------
# 
# ¤ [TEST-KO]
#
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
# # ¤ [TEST-OK]
# 
# 	CentOS Linux release 7.4.1708 (Core)
# 
# 
# 
# 
# 
# 
# 
# 
# 
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




MAISON=`pwd`
MAISON_DU_BUILD_DOCKER=$MAISON/jibl-vyos


VYOS_VERSION=1.1.7
VYOS_TARGET_ARCH=amd64
VYOS_ISO_IMAGEFILENAME=vyos-$VYOS_VERSION-$VYOS_TARGET_ARCH.iso
WHERE_TO_PULL_FROM_VYOS_ISO_IMAGEFILE=http://packages.vyos.net/iso/release/$VYOS_VERSION/$VYOS_ISO_IMAGEFILENAME




MAISON_OPERATIONS_DS_CONTENEUR=/jibl-ops
OPERATEUR_VYOS_LINUX_USER_NAME=vyos
OPERATEUR_VYOS_LINUX_USER_GRP=vyos
OPERATEUR_VYOS_LINUX_USER_PWD=vyos



# Download the latest ISO

# mkdir vyos && cd vyos
# wget http://packages.vyos.net/iso/release/1.1.7/vyos-1.1.7-amd64.iso

mkdir -p $MAISON_DU_BUILD_DOCKER && cd $MAISON_DU_BUILD_DOCKER
wget http://packages.vyos.net/iso/release/1.1.7/vyos-1.1.7-amd64.iso


# Mount the ISOs file system

mkdir rootfs
sudo mount -o loop vyos-1.1.7-amd64.iso rootfs
# Unpack the filesystem

# sudo apt-get install -y squashfs-tools # ===>> ah zut, du coup, leur recette est plutôt prévue pour s'exécuter sur un Ubuntu, moije la porte vers un centos
sudo yum install -y squashfs-tools
mkdir unsquashfs
sudo unsquashfs -f -d unsquashfs/ rootfs/live/filesystem.squashfs
# Create Docker Image


CORPORATE_PREFIX_NOM_IMAGE_DOCKER=jibl
PRODUIT_IMAGE_DOCKER=vyos
VERSIONIMAGEDOCKER=v0.0.1-SNAPSHOT
NOMIMAGEDOCKER=$CORPORATE_PREFIX_NOM_IMAGE_DOCKER/$PRODUIT_IMAGE_DOCKER:$VERSIONIMAGEDOCKER

sudo tar -C unsquashfs -c . | docker import - $NOMIMAGEDOCKER
# ça, je pense que c'est pour pousser sur le repo REMOTE d'images, au lieu du repo LOCAL d'images docker (le rpo depuis lequel on fait des docker pull)
# Donc, ça, c'est pour publier et rendre disposnible à d'autres:
# sudo docker push $NOMIMAGEDOCKER



####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
###############		DOCKER BUILD POUR ARRIVER A CREER LE USER       ################
####################################################################################

CORPORATE_PREFIX_NOM_IMAGE_DOCKER=jibl
PRODUIT_IMAGE_DOCKER=vyos
VERSIONIMAGEDOCKER=v0.0.1-SNAPSHOT
NOMIMAGEDOCKER=$CORPORATE_PREFIX_NOM_IMAGE_DOCKER/$PRODUIT_IMAGE_DOCKER:$VERSIONIMAGEDOCKER


VERSIONIMAGEDOCKER=v0.0.2-SNAPSHOT
NOM_NOUVELLE_IMAGE_DOCKER_JIBL=$CORPORATE_PREFIX_NOM_IMAGE_DOCKER/$PRODUIT_IMAGE_DOCKER:$VERSIONIMAGEDOCKER
CONTEXTE_DU_BUILD_DOCKER=/home/jibl/jibl-vyos/builddocker
mkdir -p $CONTEXTE_DU_BUILD_DOCKER
cd $CONTEXTE_DU_BUILD_DOCKER

####################################################################################
####################################################################################
######   Le dockerfile qu'il faut générer (celui-là est testé, il marche)
####################################################################################
####################################################################################
# FROM jibl/vyos:v0.0.1-SNAPSHOT
echo "FROM $NOMIMAGEDOCKER" >> ./image-jibl-vyos.2.dockerfile
# RUN useradd vyos
echo "RUN useradd $OPERATEUR_VYOS_LINUX_USER_NAME" >> ./image-jibl-vyos.2.dockerfile
# RUN mkdir -p /opes-jibl
echo "RUN mkdir -p $MAISON_OPERATIONS_DS_CONTENEUR" >> ./image-jibl-vyos.2.dockerfile
echo "USER vyos" >> ./image-jibl-vyos.2.dockerfile
echo "WORKDIR $MAISON_OPERATIONS_DS_CONTENEUR" >> ./image-jibl-vyos.2.dockerfile
# echo "CMD   ?? " >> ./image-jibl-vyos.2.dockerfile
# # CMD /bin/bash
####################################################################################
####################################################################################
####################################################################################

# Docker build
#  Bon, ce build fonctionne, mais quand j'essaie 
# 
# 
# 

# sudo docker build --tag $NOM_NOUVELLE_IMAGE_DOCKER_JIBL -f ./image-jibl-vyos.dockerfile $CONTEXTE_DU_BUILD_DOCKER # ben le build, quoi ...
sudo docker build --tag $NOM_NOUVELLE_IMAGE_DOCKER_JIBL -f ./image-jibl-vyos.2.dockerfile $CONTEXTE_DU_BUILD_DOCKER # ben le build, quoi ...
sudo docker images # et voilà la liste des images que tu as dans ton repo local docker ( --tag , c'est pratique ... ;)
sudo docker ps -a # et voilà la liste des conteneurs docker que tu as créés.
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################
####################################################################################


################  LANCEMENT DU CONTENEUR
# derrière, eux; ils disent:

# # Start using:
# docker run -d --name vyos --privileged -v /lib/modules:/lib/modules 2stacks/vyos:latest /sbin/init
# # Then run using:
# docker exec -it vyos /bin/vbash

# https://hub.docker.com/r/2stacks/vyos/
# https://www.hackster.io/2stacks
NOM_CONTENEUR_VYOS=vyos1
export NOM_CONTENEUR_VYOS
# Celui-là, il "fonctionne": il ne s'arrête pas sauvagement, mais par contre pour l'instant impossible de créer mon user vyos ou de faire su vyos, et donc IMPOSSIBLE DE FAIRE CONFIGURE
sudo docker run -d --name $NOM_CONTENEUR_VYOS --privileged -v /lib/modules:/lib/modules $NOM_NOUVELLE_IMAGE_DOCKER_JIBL /sbin/init
NOM_CONTENEUR_VYOS=vyos2
export NOM_CONTENEUR_VYOS
sudo docker run -d --name $NOM_CONTENEUR_VYOS --privileged -v /lib/modules:/lib/modules $NOM_NOUVELLE_IMAGE_DOCKER_JIBL /sbin/init
#l'affichage que j'obtiens en retour:
# # [jibl@pc-125 jibl-vyos]$ sudo docker ps -a
# # CONTAINER ID        IMAGE                       COMMAND             CREATED             STATUS              PORTS               NAMES
# # 475312523fd4        jibl/vyos:v0.0.1-SNAPSHOT   "/sbin/init"        8 seconds ago       Up 7 seconds                            vyos
# 
# 
# ==>> donc une fois ce docker run fait, le conteneur reste en exécution, il n'a pas le statut "Exited (... ago)"
# 
# Then run using:   
#############################
# sudo docker exec -it $NOM_CONTENEUR_VYOS /bin/vbash
# Je rentre dans le conteneur, et j'essaie "configure". Résultat: je suis "root", et VyOS m'oblige à utiliser un utilisateur "vyos", qui a les droits sudoers, qui est dans le groupe vyos, et qui a come mot de passe vyos."
# aller, dans le conteneur, je créée un userlinux "vyos/vyos", je lui donne les droits sudoers avec ajout dans /etc/sudoers.
#############################

#############################
#  À ce stade, si j'essaie :
#       sudo docker exec --user vyos -it vyos /bin/vbash
# j'ai une erreur très claire qui me dit "unable to find user vyos: no matching entries in passwd file"

# clear
echo " ---------------------------------------------------------  "
echo " ---------------------------------------------------------  "
echo " ---------------------------------------------------------  "
sudo docker ps -a
sudo docker images
echo "sudo docker ps -a"
echo "sudo docker images"
echo ""
echo "sudo docker exec -it vyos /bin/vbash"
echo ""
echo " VERIFICATION DU LOG ERREURS "
echo ""
echo " ---------------------------------------------------------  "
echo " ---------------------------------------------------------  "
echo " ---------------------------------------------------------  "
read











clear
sudo docker ps -a
sudo docker images
echo "sudo docker ps -a"
echo "sudo docker images"
echo ""
echo "sudo docker exec -it vyos /bin/vbash"
echo ""
echo "Pour la suite : Test d'images diverses de VyOS dans un conteneur docker "
echo ""
echo ""
read


#######################################################################################
# Test de TOUTES (celles qui ont un minimum d'instructions documentées)
# les images trouvées sur le DOCKERHUB, en cherchant "vyos" (on peut pas faire mieux.)
#######################################################################################
NOM_NOUVELLE_IMAGE_DOCKER_TEST=mnagaku/vyos:latest
export NOM_NOUVELLE_IMAGE_DOCKER_TEST

# test d'image : https://hub.docker.com/r/mnagaku/vyos/
NOM_NOUVELLE_IMAGE_DOCKER_TEST=mnagaku/vyos:latest
sudo docker pull $NOM_NOUVELLE_IMAGE_DOCKER_TEST

NOM_CONTENEUR_VYOS=vyos-test1
sudo docker run -d --name $NOM_CONTENEUR_VYOS --privileged -v /lib/modules:/lib/modules $NOM_NOUVELLE_IMAGE_DOCKER_TEST /sbin/init
NOM_CONTENEUR_VYOS=vyos-test12
sudo docker run -d --name $NOM_CONTENEUR_VYOS --net=host --privileged -v /lib/modules:/lib/modules $NOM_NOUVELLE_IMAGE_DOCKER_TEST /sbin/init

clear
sudo docker ps -a
sudo docker images
echo "sudo docker ps -a"
echo "sudo docker images"
echo "sudo docker exec -it vyos /bin/vbash"
echo ""
echo "   TEST IMAGE DOCKER : $NOM_NOUVELLE_IMAGE_DOCKER_TEST   "
echo "   N.B. : le conteneur $$NOM_CONTENEUR_VYOS a été démarré avec  l'option [--net=host]   "
echo ""
read

########################################################################################################################################################
# résultats test: NULL (sortie console:)
########################################################################################################################################################
		# [jibl@pc-125 ~]$ sudo docker ps -a

		# CONTAINER ID        IMAGE                    COMMAND             CREATED             STATUS              PORTS               NAMES
		# be32c55bb932        stano/vyos:1.1.8-amd64   "/sbin/init"        4 minutes ago       Up 4 minutes                            vyos
		# 8a7ca17176e6        mnagaku/vyos:latest      "/sbin/init"        8 minutes ago       Up 8 minutes                            vyos-test1
		
		# [jibl@pc-125 ~]$ sudo docker exec -it vyos-test1 /bin/vbash
		# vbash-4.1# su - vyos
		
		# Unknown id: vyos
		
		# vbash-4.1# configure
		
		# You are attempting to enter configuration mode as root.
		# It may have unintended consequences and render your system
		# unusable until restart.
		# Please do it as an administrator level VyOS user instead.
		
		# vbash-4.1#

########################################################################################################################################################



# test d'image : https://hub.docker.com/r/stano/vyos/
# NOM_NOUVELLE_IMAGE_DOCKER_TEST=stano/vyos:1.1.8-amd64
NOM_NOUVELLE_IMAGE_DOCKER_TEST=stano/vyos:latest
sudo docker pull $NOM_NOUVELLE_IMAGE_DOCKER_TEST

NOM_CONTENEUR_VYOS=vyos-test2
sudo docker run -d --name $NOM_CONTENEUR_VYOS --privileged -v /lib/modules:/lib/modules $NOM_NOUVELLE_IMAGE_DOCKER_TEST /sbin/init
# sudo docker run -d --name vyos                --privileged -v /lib/modules:/lib/modules stano/vyos:1.1.8-amd64 /sbin/init
clear
sudo docker ps -a
sudo docker images
echo "sudo docker ps -a"
echo "sudo docker images"
echo "sudo docker exec -it vyos /bin/vbash"
echo ""
echo "   TEST IMAGE DOCKER : $NOM_NOUVELLE_IMAGE_DOCKER_TEST   "
echo ""
read

########################################################################################################################################################
# résultats test: NULL (sortie console:)
########################################################################################################################################################
		# [jibl@pc-125 ~]$ sudo docker ps -a

		# CONTAINER ID        IMAGE                    COMMAND             CREATED             STATUS              PORTS               NAMES
		# be32c55bb932        stano/vyos:1.1.8-amd64   "/sbin/init"        4 minutes ago       Up 4 minutes                            vyos
		# 8a7ca17176e6        mnagaku/vyos:latest      "/sbin/init"        8 minutes ago       Up 8 minutes                            vyos-test1
		
		# [jibl@pc-125 ~]$ sudo docker exec -it vyos-test1 /bin/vbash
		# vbash-4.1# su - vyos
		
		# Unknown id: vyos
		
		# vbash-4.1# configure
		
		# You are attempting to enter configuration mode as root.
		# It may have unintended consequences and render your system
		# unusable until restart.
		# Please do it as an administrator level VyOS user instead.
		
		# vbash-4.1#

########################################################################################################################################################



# test d'image : https://hub.docker.com/r/higebu/vyos/
# NOM_NOUVELLE_IMAGE_DOCKER_TEST=stano/vyos:1.1.8-amd64
NOM_NOUVELLE_IMAGE_DOCKER_TEST=higebu/vyos:latest
sudo docker pull $NOM_NOUVELLE_IMAGE_DOCKER_TEST

NOM_CONTENEUR_VYOS=vyos-test3
sudo docker run -d --name $NOM_CONTENEUR_VYOS --privileged -v /lib/modules:/lib/modules $NOM_NOUVELLE_IMAGE_DOCKER_TEST /sbin/init
# sudo docker run -d --name vyos                --privileged -v /lib/modules:/lib/modules stano/vyos:1.1.8-amd64 /sbin/init
clear
sudo docker ps -a
sudo docker images
echo "sudo docker ps -a"
echo "sudo docker images"
echo "sudo docker exec -it vyos /bin/vbash"
echo ""
echo "   TEST IMAGE DOCKER : $NOM_NOUVELLE_IMAGE_DOCKER_TEST   "
echo ""
read

########################################################################################################################################################
# résultats test: NULL (sortie console:)
########################################################################################################################################################
		# [jibl@pc-125 ~]$ sudo docker ps -a

		# CONTAINER ID        IMAGE                    COMMAND             CREATED             STATUS              PORTS               NAMES
		# be32c55bb932        stano/vyos:1.1.8-amd64   "/sbin/init"        4 minutes ago       Up 4 minutes                            vyos
		# 8a7ca17176e6        mnagaku/vyos:latest      "/sbin/init"        8 minutes ago       Up 8 minutes                            vyos-test1
		
		# [jibl@pc-125 ~]$ sudo docker exec -it vyos-test1 /bin/vbash
		# vbash-4.1# su - vyos
		
		# Unknown id: vyos
		
		# vbash-4.1# configure
		
		# You are attempting to enter configuration mode as root.
		# It may have unintended consequences and render your system
		# unusable until restart.
		# Please do it as an administrator level VyOS user instead.
		
		# vbash-4.1#

########################################################################################################################################################




# à tester : https://www.higebu.com/blog/2014/12/10/docker-on-vyos/#.WmrVk-co-Uk
# c'est aussi lui: https://hub.docker.com/r/higebu/vyos/





# a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   
# a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   
# a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   
# a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   
# a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   
# a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   
# a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   
# a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   
# a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   
# a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   
# a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   
# a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   
# a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   
# a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   
# a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   a exécuter dans le conteneur:   

# MAISON_OPERATIONS_DS_CONTENEUR=/jibl-ops
# OPERATEUR_VYOS_LINUX_USER_NAME=vyos
# OPERATEUR_VYOS_LINUX_USER_GRP=vyos
# OPERATEUR_VYOS_LINUX_USER_PWD=vyos

# mkdir -p $MAISON_OPERATIONS_DS_CONTENEUR
# création user vyos, groupe vyos

# sudo groupadd $OPERATEUR_VYOS_LINUX_USER_GRP  # j'ai véirfié, il n'existe pas dans le conteneur au départ
# sudo useradd $OPERATEUR_VYOS_LINUX_USER_NAME # créée le groupe à la volée
# sudo useradd -g $OPERATEUR_VYOS_LINUX_USER_GRP $OPERATEUR_VYOS_LINUX_USER_NAME
# sudo useradd -ms /bin/bash $OPERATEUR_VYOS_LINUX_USER_NAME
# sudo passwd $OPERATEUR_VYOS_LINUX_USER_NAME
# sudo usermod -aG $OPERATEUR_VYOS_LINUX_USER_GRP $OPERATEUR_VYOS_LINUX_USER_NAME

# droits sudoers
# mkdir -p $MAISON_OPERATIONS_DS_CONTENEUR/cuisine-sudoers
# sudo cp /etc/sudoers $MAISON_OPERATIONS_DS_CONTENEUR/cuisine-sudoers/sudoers.bckup

# rm -f $MAISON_OPERATIONS_DS_CONTENEUR/cuisine-sudoers/sudoers.ajout
# echo "" >> $MAISON_OPERATIONS_DS_CONTENEUR/cuisine-sudoers/sudoers.ajout
# echo "# Allow DEPLOYEUR-MAVEN-PLUGIN to execute deployment commands" >> $MAISON_OPERATIONS_DS_CONTENEUR/cuisine-sudoers/sudoers.ajout
# echo "$OPERATEUR_VYOS_LINUX_USER_NAME ALL=NOPASSWD: /usr/bin/docker cp*, /usr/bin/docker restart*, /usr/bin/docker exec*, /bin/rm -rf ./$NOM_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN" >> $MAISON_OPERATIONS_DS_CONTENEUR/cuisine-sudoers/sudoers.ajout
# echo "$OPERATEUR_VYOS_LINUX_USER_NAME ALL=NOPASSWD: ALL" >> $MAISON_OPERATIONS_DS_CONTENEUR/cuisine-sudoers/sudoers.ajout
# echo "" >> $MAISON_OPERATIONS_DS_CONTENEUR/cuisine-sudoers/sudoers.ajout

# clear
# echo " --- Juste avant de toucher /etc/sudoers:  "
# echo "			" 
# echo "			cat $MAISON_OPERATIONS_DS_CONTENEUR/cuisine-sudoers/sudoers.ajout" 
# echo "			" 
# echo " ---------------------------------------------------------------------------------------------------- "
# cat $MAISON_OPERATIONS_DS_CONTENEUR/cuisine-sudoers/sudoers.ajout
# echo " ---------------------------------------------------------------------------------------------------- "
# read
# cat $MAISON_OPERATIONS_DS_CONTENEUR/lauriane/sudoers.ajout | sudo EDITOR='tee -a' visudo
# sudo cp $MAISON_OPERATIONS_DS_CONTENEUR/lauriane/sudoers.ajout /etc/sudoers











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
clear