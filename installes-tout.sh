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
# >>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<
# > construction du conteneur SERVEUR JEE  <
# >    -------------------------------     <
# >    ce conteneur est une dépendance     <
# >    -------------------------------     <
# >>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<
#
# NOM_CONTENEUR_TOMCAT=ciblededeploiement-composant-srv-jee

VERSION_TOMCAT=10.1

# docker run -it --name $NOM_CONTENEUR_TOMCAT --rm -p $NUMERO_PORT_SRV_JEE:8080 tomcat:8.0
docker run --name $NOM_CONTENEUR_TOMCAT --rm -p $NUMERO_PORT_SRV_JEE:8080 tomcat:$VERSION_TOMCAT
# http://adressIP:8888/


# >>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<
# >>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<
# >    construction du conteneur SGBDR     <
# >    -------------------------------     <
# >    ce conteneur est une dépendance     <
# >    -------------------------------     <
# >>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<
#

# NOM_CONTENEUR_SGBDR=ciblededeploiement-composant-sgbdr
# NUMERO_PORT_SGBDR=3308
NOM_BDD_APPLI=bdd_appli_lauriane

MARIADB_MDP_ROOT_PASSWORD=peuimporte

# DB_MGMT_USER_NAME=lauriane
# DB_MGMT_USER_PWD=lauriane

# DB_APP_USER_NAME=appli-de-lauriane
# DB_APP_USER_PWD=mdp@ppli-l@urian3

# Avec cet utilisateur, on va créer la BDD $NOM_BDD_APPLI, et
# créer l'utilisateur $DB_APP_USER_NAME
MARIADB_DB_MGMT_USER_NAME=DB_MGMT_USER_NAME
MARIADB_DB_MGMT_USER_PWD=DB_MGMT_USER_PWD


MARIADB_DB_APP_USER_NAME=DB_APP_USER_NAME
MARIADB_DB_APP_USER_PWD=DB_APP_USER_PWD

# enorrrmeee ideeee : FAIRE UN CONTENEUR DOCKER DANS LEQUEL J'EXECUTE CES SCRIPTS COMMIT AVEC POUR NOM D 'image snapshtot:
# 		¤ CHANGER_ADRESSE_IP
# 		¤ ccc
# 		¤ ccc
# 		¤ ccc
VERSION_MARIADB=10.1
NO_PORT_EXTERIEUR_MARIADB=$NUMERO_PORT_SGBDR
NOM_CONTENEUR_MARIADB=$NOM_CONTENEUR_SGBDR
REPERTOIRE_HOTE_BCKUP_CONF_MARIADB=$MAISON/mariadb-conf/bckup
CONF_MARIADB_A_APPLIQUER=$MAISON/conf.mariadb

# > créer le conteneur avec usr, et root_user
# La "--collation-server" permet de définir l'ordre lexicographique des mots formés à partir de l'alphabet définit par le jeu de caractères utilisé
# La "--character-set-server" permet de définir l'encodage et le jeu de caractères utilisé
docker run --name $NOM_CONTENEUR_MARIADB -e MYSQL_ROOT_PASSWORD=$MARIADB_MDP_ROOT_PASSWORD -e MYSQL_USER=$MARIADB_DB_MGMT_USER_NAME -e MYSQL_PASSWORD=$MARIADB_DB_MGMT_USER_PWD -p $NO_PORT_EXTERIEUR_MARIADB:3306 -v $REPERTOIRE_HOTE_BCKUP_CONF_MARIADB:/etc/mysql -d mariadb:$VERSION_MARIADB  --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
# test: sudo docker exec -it $NOM_CONTENEUR_SGBDR /bin/bash
# > APPPLIQUER config voulue
docker cp $CONF_MARIADB_A_APPLIQUER $NOM_CONTENEUR_MARIADB:./etc/mysql/mycnf
# docker exec $NOM_CONTENEUR_MARIADB /bin/bash| :./etc/mysql/mycnf
docker restart $NOM_CONTENEUR_TOMCAT
# > configurer l'accès "remote" pour les 2 utilisateurs  $DB_MGMT_USER_NAME  et  $DB_APP_USER_NAME
# https://mariadb.com/kb/en/library/configuring-mariadb-for-remote-client-access/
clear
echo POINT DEBUG
echo VERIF CONF DS CONTENEUR
echo "   sudo docker exec -it ccc /bin/bash"
read


# générer les 2 fichiers SQL
rm -f ./creer-bdd-apppli.sql
echo "CREATE $NOM_BDD_APPLI; " >> ./creer-bdd-apppli.sql
# > créer la BDD de l'application et créer l'utilisateur applicatif
docker exec -it $NOM_CONTENEUR_SGBDR < ./creer-bdd-apppli.sql
# > créer l'utilisateur applicatif
rm -f ./creer-utilisateur-applicatif.sql
echo "use mysql; " >> ./creer-utilisateur-applicatif.sql
# echo "select @mdp:= PASSWORD('$MARIADB_DB_APP_USER_PWD');" >> ./creer-utilisateur-applicatif.sql
echo "CREATE USER '$MARIADB_DB_APP_USER_NAME'@'%' IDENTIFIED BY '$MARIADB_DB_APP_USER_PWD';" >> ./creer-utilisateur-applicatif.sql
echo "GRANT ALL PRIVILEGES ON bddappli.* TO 'techonthenet'@'%' WITH GRANT OPTION;" >> ./creer-utilisateur-applicatif.sql
# > script shell pour sql créer l'utilisateur applicatif
rm -f ./creer-bdd-apppli.sh
echo "mysql -u root -p$MARIADB_MDP_ROOT_PASSWORD < ./creer-bdd-apppli.sql" > ./creer-bdd-apppli.sh
docker cp ./creer-bdd-apppli.sql $NOM_CONTENEUR_SGBDR:. 
docker cp ./creer-bdd-apppli.sh $NOM_CONTENEUR_SGBDR:. 
docker exec -it $NOM_CONTENEUR_SGBDR /bin/bash < ./creer-bdd-apppli.sh
# ou alors:
# docker exec -it $NOM_CONTENEUR_SGBDR /bin/bash < ./creer-bdd-apppli.sh
# TODO: finir avec creer-utilisateur-applicatif
rm -f ./creer-utilisateur-applicatif.sh
echo "use mysql; " >> ./creer-utilisateur-applicatif.sh
docker cp ./creer-utilisateur-applicatif.sql $NOM_CONTENEUR_SGBDR:. 
docker cp ./creer-utilisateur-applicatif.sh $NOM_CONTENEUR_SGBDR:. 
docker exec -it $NOM_CONTENEUR_SGBDR /bin/bash < ./creer-utilisateur-applicatif.sh
# ou alors:
# docker exec -it $NOM_CONTENEUR_SGBDR /bin/bash | ./creer-utilisateur-applicatif.sh
# trop faigué

# > mysql_secure_installation
