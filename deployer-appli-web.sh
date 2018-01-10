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
# Cette fonction permet d'afficher un premier message explicatif.
afficher_message_presentation_initiale () {
	echo "Il se peut";
	echo "";
}

afficher_message_prerequis () {
	echo "Votre machine Virtuelle ";
	echo "laquelle vous allez expérimenter, de";
	echo "manière à rendre le déroulement de vos opérations le plus confortable possible.";
	echo "Vos expérimentations vont se faire dans une Machine Virtuelle Virtual Box.";
	echo "";
}

# ---------------------------------------------------------
# [description]
# ---------------------------------------------------------
# Cette fonction permet de configurer une ip statique 
# pour la machine.
# 
# Afin de décider quel interface réseau linux sera
# utilisé, cette fonction procède de la manière suivante:
# 
#  - si aucun argument n'est passé à cette fonction, alors 
#    ce script demande à l'utilisateur de spécifier un
#    nom d'interface réseau linux.
#  - si l'utilisateur ne fournit aucun nom d'interface
#    réseau linux (il a simplement pressé la touche Entrée),
#    le nom de l'interface par défaut sera utilisé, soit
#    "$NOM_INTERFACE_RESEAU_A_RECONFIGURER_PAR_DEFAUT".
#  - si un argument et un seul argument est passé
#    à cette fonction, alors le premier argument passé sera
#    le nom d'interface utilisé.
#  - si plus d'un argument est passé, alors seule la
#    première valeur passée en argument sera utilisée
#    comme expliqué par les 3 points précédents.
#    Les autres valeurs passées seront ignorées.
# ---------------------------------------------------------
# [signature]
# ---------------------------------------------------------
#
# 	$1 => le nom de l'interface réseau linux à 
#         re-configurer.
#
# ---------------------------------------------------------


demander_infos_deploiement () {

# VAR.
# ----

FICHIER_WAR_A_DEPLOYER_PAR_DEFAUT=$HOME/lauriane/appli-a-deployer-pour-test.war
FICHIER_WAR_A_DEPLOYER=$FICHIER_WAR_A_DEPLOYER_PAR_DEFAUT




# Gestion des valeurs passées en paramètre
# ----------------------------------------

NBARGS=$#
clear
if [ $NBARGS -eq 0 ]
then
	echo "Quel est le nom de fichier de l'artefact war à déployer?"
	echo "(Par défaut l'artefact [$FICHIER_WAR_A_DEPLOYER] sera déployé"
	read SAISIE_UTILISATEUR_NOMWAR
	FICHIER_WAR_A_DEPLOYER=$SAISIE_UTILISATEUR_NOMWAR
else
	FICHIER_WAR_A_DEPLOYER=$1
fi

# confirmation nom interface réseau linux à reconfigurer 
clear
echo "Vous confirmez vouloir déployer l'artefact : [$FICHIER_WAR_A_DEPLOYER] ?"
echo "Répondez par Oui ou Non (o/n). Répondre Non annulera le déploiement."
read VOUSCONFIRMEZ
case "$VOUSCONFIRMEZ" in
	[oO] | [oO][uU][iI]) echo "L'artefact [$FICHIER_WAR_A_DEPLOYER] va être déployé" ;;
	[nN] | [nN][oO][nN]) echo "Déploiement annulé.";exit ;;
esac

}










############################################################
############################################################
#					exécution des opérations			   #
############################################################
############################################################



# construction d'un conteneur tomcat 
clear
echo "Quand tu appuieras sur Entrée, attends quelque secondes, et ton serveur tomcat sera accessible à:"
echo "		http://adressIP-detaVM:8888/"
echo "Quand tu veux."
read
sudo docker run -it --name ciblededeploiement --rm -p 8888:8080 tomcat:8.0
# http://adressIP:8888/


NOM_CONTENEUR_TOMCAT=ciblededeploiement-composant-srv-jee
FICHIER_WAR_A_DEPLOYER=./appli-a-deployer-pour-test.war

demander_infos_deploiement $1

sudo docker cp $FICHIER_WAR_A_DEPLOYER $NOM_CONTENEUR_TOMCAT:/usr/local/tomcat/webapps
sudo docker restart $NOM_CONTENEUR_TOMCAT
