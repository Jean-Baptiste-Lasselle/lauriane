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


export URI_REPO_GIT_CODE_SOURCE_APP_SCALA
ARGUMENT_PASSE_A_L_EXECUTION=$1
if [ $# -eq 0 ]; then 
    echo "No arguments supplied"
    URI_REPO_GIT_CODE_SOURCE_APP_SCALA=https://github.com/Jean-Baptiste-Lasselle/siteweb-usinelogicielle.com
else 
	# if [ $# -eq 0 ]; then 
		# echo "No arguments supplied"
		# URI_REPO_GIT_CODE_SOURCE_APP_SCALA=https://github.com/Jean-Baptiste-Lasselle/siteweb-usinelogicielle.com
	# else 
		# URI_REPO_GIT_CODE_SOURCE_APP_SCALA=$ARGUMENT_PASSE_A_L_EXECUTION
	# fi
    URI_REPO_GIT_CODE_SOURCE_APP_SCALA=$ARGUMENT_PASSE_A_L_EXECUTION
fi


export PROVISIONNING_HOME=$HOME/provisionning-scala
# rm -rf $PROVISIONNING_HOME
# mkdir -p $PROVISIONNING_HOME
# à demander interactivement à l'utilisateur: "DAns quel répertoire souhaitez-vous que l'application scala soit déployée? C'est dans ce répertoire que la commande st sera lancée. [Par défaut, le répertoire utilsié sera le répertoire ..]:"
export REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT=$HOME/software-factory-website
# export WHERE_I_WAS_CLONED=$PROVISIONNING_HOME/recettes-operations
# à demander interactivement à l'utilisateur: "Quel utilisateur linux souhaitez-vous que le deployeur-maven-plugin utilise?"
export MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME=lauriane
# lors de son installation, PostGReSQL créée un utilisateur linux, avec
# lequel il est possible d'utiliser le client psql (pour crééer/modifier/détruire des BDD)
# Ce nom d'utilisateur linux est utilisé pour la provision scala, et pour sa configuration sudoers cf. [recette-provisionning-lx-user-provision-scala.sh]
export USER_SQL_CREE_PAR_INSTALL_POSTGRE=postgres

# Pas tant qu'on a une dépendance au script de lauraine, lulu... ======================>>>> dépendance
# export REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT/home/lauriane/tulavuvlulu

# création du répertoire de travail pour le provisionning
rm -rf $REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT
mkdir -p $REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT


############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
##########################											OPERATIONS													############################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
# 
sudo apt-get install -y dialog apt-utils
# On exécute d'abord la configuration sudoers, parce que la commande SBT démarre un process qui ne se termine pas.
cd $PROVISIONNING_HOME
# chmod +x ./recette-provisionning-lx-user-deployeur-maven-plugin.sh
chmod +x ./recette-provisionning-lx-user-provision-sql.sh
chmod +x ./recette-provisionning-scala.sh
# si un problème survient pendant le provisionning du user linux pour le [deployeur-maven-plugin]
# ./recette-provisionning-lx-user-deployeur-maven-plugin.sh && ./recette-provisionning-lx-user-provision-sql.sh && ./recette-provisionning-scala.sh
# Il n'est ni logique, ni possible de configurer les droits sudoers de l'opérateur linux que le [deployeur-maven-plugin] utilise, pendant
# que le [deployeur-maven-plugin] agit....
./recette-provisionning-lx-user-provision-sql.sh && ./recette-provisionning-scala.sh