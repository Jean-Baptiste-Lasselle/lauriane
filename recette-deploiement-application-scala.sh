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

# export URI_REPO_GIT_DEPLOIEMENTS_APP_SCALA=""
export REPERTOIRE_PROCHAIN_BUILD=""
export REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT=""
if [ $# -eq 0 ]; then 
    echo "No arguments supplied for [REPERTOIRE_PROCHAIN_BUILD], applying default value."
    REPERTOIRE_PROCHAIN_BUILD=$HOME/next-build-app-scala
	echo "No argument supplied for [REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT], applying default value."
	REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT=$HOME/software-factory-website
else
	REPERTOIRE_PROCHAIN_BUILD=$1
	if [ $# -eq 1 ]; then 
		echo "No argument supplied for [REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT], applying default value."
        REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT=$HOME/software-factory-website
	else 
	    REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT=$2
	fi
fi

# export PROVISIONNING_HOME=$HOME/provisionning-scala
# à demander interactivement à l'utilisateur: "Quel utilisateur linux souhaitez-vous que le deployeur-maven-plugin utilise?"
# export MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME=lauriane
# à demander interactivement à l'utilisateur: "Dans quel répertoire souhaitez-vous que l'application scala soit déployée? C'est dans ce répertoire que la commande st sera lancée. [Par défaut, le répertoire utilsié sera le répertoire ..]:"

# Pas tant qu'on a une dépendance au script de lauraine, lulu... ======================>>>> dépendance
# export REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT/home/lauriane/tulavuvlulu


# création des répertoires de travail pour le provisionning
# rm -rf $PROVISIONNING_HOME
# mkdir -p $PROVISIONNING_HOME
# mkdir -p $PROVISIONNING_HOME/recettes-cible-deploiement
# rm -rf $REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT
# mkdir -p $REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT



# À l'opérateur: Mises à jour système de la LTS, avant début des opérations - nepeut être versionné synchrone avec le versionning d'une recette de déploiement



############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
##########################											OPERATIONS											############################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################

# export URI_REPO_GIT_DEPLOIEMENTS_APP_SCALA=https://github.com/Jean-Baptiste-Lasselle/siteweb-usinelogicielle.com
#
# On se débarasse de la version précédente de l'applciation
rm -rf $REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT
mkdir -p $REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT
# On récupère le code source de la dernière version l'application
# git clone $URI_REPO_GIT_DEPLOIEMENTS_APP_SCALA $REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT
echo "DEBUG JIBL: [REPERTOIRE_PROCHAIN_BUILD=$REPERTOIRE_PROCHAIN_BUILD]"
# Au lieu de récupérer le code sourec, on récupère l'artefacct exécutable qu'on copie dans 
cp $REPERTOIRE_PROCHAIN_BUILD/software-factory $REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT

# et voilà comment très simplement démarrer l'application.
$REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT/software-factory -Dplay.evolutions.db.default.autoApply=true

