############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
##########################											ENV.														############################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
# 
# 

PROVISIONNING_HOME=$HOME/provisionning-scala
# à demander interactivement à l'utilisateur: "Quel utilisateur linux souhaitez-vous que le deployeur-maven-plugin utilise?"
export MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME=lauriane
# à demander interactivement à l'utilisateur: "DAns quel répertoire souhaitez-vous que l'application scala soit déployée? C'est dans ce répertoire que la commande sbt sera lancée. [Par défaut, le répertoire utilsié sera le répertoire ..]:"
export REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT=$PROVISIONNING_HOME/software-factory-website

# Pas tant qu'on a une dépendance au script de lauraine, lulu... ======================>>>> dépendance
# export REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT/home/lauriane/tulavuvlulu


# création des répertoires de travail pour le provisionning
rm -rf $PROVISIONNING_HOME
mkdir -p $PROVISIONNING_HOME
rm -rf $PROVISIONNING_HOME/recettes-cible-deploiement
mkdir -p $PROVISIONNING_HOME/recettes-cible-deploiement

# à l'opérateur: Mises à jour système de la LTS, avant début des opérations - nepeut être versionné synchrone avec le versionning d'une recette de déploiement



############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
##########################											OPERATIONS											############################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
#
############################################################################################################################################################
# ################################   				Gestion des sudoers pour le deployeur-maven-plugin   					################################
############################################################################################################################################################
# TODO =>>> mettre à jour la configuration /etc/sudoers
rm -f $PROVISIONNING_HOME/sudoers.ajout
# export NOM_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN=lauriane-deploiement
# export URL_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN=https://github.com/Jean-Baptiste-Lasselle/lauriane-deploiement.git


echo "" >> $PROVISIONNING_HOME/sudoers.ajout
echo "# Allow DEPLOYEUR-MAVEN-PLUGIN to execute scala deployment commands" >> $PROVISIONNING_HOME/sudoers.ajout
echo "$MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME ALL=NOPASSWD: /bin/rm -rf $REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT" >> $PROVISIONNING_HOME/sudoers.ajout
echo "" >> $PROVISIONNING_HOME/sudoers.ajout
# echo "" >> $PROVISIONNING_HOME/lauriane/sudoers.ajout
clear
echo " --- Justez avaant de toucher /etc/sudoers:  "
echo "			" 
echo "			cat $PROVISIONNING_HOME/lauriane/sudoers.ajout" 
echo "			" 
echo " ---------------------------------------------------------------------------------------------------- "
cat $PROVISIONNING_HOME/sudoers.ajout
echo " ---------------------------------------------------------------------------------------------------- "
# echo " ---------	Pressez une touche pour ajouter en fin de /etc/sudoers 							------- "
# echo " ---------------------------------------------------------------------------------------------------- "
# read
# cat $MAISON/lauriane/sudoers.ajout >> /etc/sudoers
# echo 'foobar ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo

# MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME=lauriane
# MVN_PLUGIN_OPERATEUR_LINUX_USER_PWD=lauriane

# celui-ci marche, c'est testé:
cat $PROVISIONNING_HOME/sudoers.ajout | sudo EDITOR='tee -a' visudo

# clear
echo " ---------------------------------------------------------------------------------------------------- "
echo " --- De plus, l'utilisateur linux que votre plugin  "
echo " --- doit utiliser est: "
echo " --- 				 "
echo " --- 				nom d'utilisateur linux: $MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME"
echo " --- 				 "
echo " --- 				mot de passe: $MVN_PLUGIN_OPERATEUR_LINUX_USER_PWD"
echo " --- 				 "
echo " --- "
echo " --- "
echo " contenu du fichier         /etc/sudoers|grep $MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME       :"
cat /etc/sudoers|grep $MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME
echo " --- "
echo " --- "
echo " --- "
echo " ---------------------------------------------------------------------------------------------------- "
echo " ----------  Pressez une touche pour lancer le démarrage intiial de l'applciation Scala. "
echo " ---------------------------------------------------------------------------------------------------- "
read



git clone https://github.com/laurianemollier/ubuntu-script/ $PROVISIONNING_HOME/recettes-cible-deploiement
sudo chmod +x $PROVISIONNING_HOME/recettes-cible-deploiement/install-web-site.sh
sudo $PROVISIONNING_HOME/recettes-cible-deploiement/install-web-site.sh


# DOCKER POSTGRESQL:  https://amattn.com/p/tutorial_postgresql_usage_examples_with_docker.html

# slick.dbs.default.db.url="jdbc:postgresql://127.0.0.1:5432/software-factory"


