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
# export WHERE_I_WAS_CLONED=$PROVISIONNING_HOME/recettes-operations
# à demander interactivement à l'utilisateur: "Quel utilisateur linux souhaitez-vous que le deployeur-maven-plugin utilise?"
export MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME=lauriane
# à demander interactivement à l'utilisateur: "DAns quel répertoire souhaitez-vous que l'application scala soit déployée? C'est dans ce répertoire que la commande st sera lancée. [Par défaut, le répertoire utilsié sera le répertoire ..]:"
export REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT=$HOME/software-factory-website

# Pas tant qu'on a une dépendance au script de lauraine, lulu... ======================>>>> dépendance
# export REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT/home/lauriane/tulavuvlulu

# création des répertoires de travail pour le provisionning
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
# Je ne sais pas encore pourquoi, mais je dois exécuter ceci: (sinon j'ai une erreur)
sudo apt-get install -y dialog apt-utils
# On exécute d'abord la configuration sudoers, parce que la commande SBT démarre un process qui ne se termine pas.
cd $PROVISIONNING_HOME
chmod +x ./recette-provisionning-lx-user-deployeur-maven-plugin.sh
chmod +x ./recette-provisionning-scala.sh
# si un problème survient pendant le provisionning du user linux pour le [deployeur-maven-plugin]
./recette-provisionning-lx-user-deployeur-maven-plugin.sh && ./recette-provisionning-scala.sh