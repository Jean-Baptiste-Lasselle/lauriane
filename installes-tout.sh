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
#					exécution des opérations			   #
############################################################
############################################################

# installation docker
apt-get remove -y apt-transport-https ca-certificates curl software-properties-common
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg|apt-key add -

# config repo ubuntu contenant les dépendances docker
apt-key fingerprint 0EBFCD88 >> ./VERIF-EMPREINTE-CLE-REPO.lauriane
# le fichier "./VERIF-EMPREINTE-CLE-REPO.lauriane" doit contenir:
# 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"



apt-get update -y

apt-get install -y docker-ce

usermod -aG docker $USER

systemctl enable docker
systemctl start docker


clear
##########################################################
##### MONTEE INFRASTRUCTURE CIBLE DE DEPLOIEMENT #########
##########################################################

# >>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<
# > construction du conteneur SERVEUR JEE  <
# >>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<
#
# NOM_CONTENEUR_TOMCAT=ciblededeploiement-composant-srv-jee

VERSION_TOMCAT=10.1

# docker run -it --name $NOM_CONTENEUR_TOMCAT --rm -p $NUMERO_PORT_SRV_JEE:8080 tomcat:8.0
docker run --name $NOM_CONTENEUR_TOMCAT --rm -p $NUMERO_PORT_SRV_JEE:8080 tomcat:$VERSION_TOMCAT
# http://adressIP:8888/


# >>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<
# >     construction du conteneur SGBDR    <
# >>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<
#
# NOM_CONTENEUR_SGBDR=ciblededeploiement-composant-sgbdr
# NUMERO_PORT_SGBDR=3308
DB_NAME=bdd_appli_lauriane

# Avec cet utilisateur, on va créer la BDD $DB_NAME, et
# créer l'utilisateur $DB_APP_USER_NAME
#
DB_MGMT_USER_NAME=lauriane
DB_MGMT_USER_PWD=lauriane

DB_APP_USER_NAME=appli-de-lauriane
DB_APP_USER_PWD=mdp@ppli-l@urian3

VERSION_MARIADB=10.1

# > créer le conteneur avec usr, et root_user
# La "--collation-server" permet de définir l'ordre lexicographique des mots formés à partir de l'alphabet définit par le jeu de caractères utilisé
# La "--character-set-server" permet de définir l'encodage et le jeu de caractères utilisé
docker run --name $NOM_CONTENEUR_SGBDR -e MYSQL_ROOT_PASSWORD=peuimporte -e MYSQL_USER=$DB_MGMT_USER_NAME -e MYSQL_PASSWORD=$DB_MGMT_USER_PWD -p $NUMERO_PORT_SGBDR:3306 -d mariadb:$VERSION_MARIADB  --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

# > configurer l'accès "remote" pour les 2 utilisateurs  $DB_MGMT_USER_NAME  et  $DB_APP_USER_NAME
# https://mariadb.com/kb/en/library/configuring-mariadb-for-remote-client-access/

# > créer la BDD
docker exec -it $NOM_CONTENEUR_SGBDR /bin/bash
# > mysql_secure_installation
