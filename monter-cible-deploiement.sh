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
# Cette fonction permet de donner des valeurs aux variables
# d'environnement:
#		¤ {NOM_CONTENEUR_TOMCAT} 	
#		¤ {NUMERO_PORT_SRV_JEE} 	--no-port-srv-jee
#		¤ {NUMERO_PORT_SGBDR} 		--no-port-sgbdr
# 
# Et ce, en procédant de la manière suivante:
#  - si ce script est invoqué avec l'option 
#    "--all-defaults", alors toutes les variables
#    d'environnement prennent leur valeur par défaut.
#  - si ce script est invoqué avec l'option "--ask-me",
#    et l'option "--all-defaults", alors message d'erreur
#  - si ce script est invoqué avec l'option "--ask-me",
#    alors les valeurs des variables d'environnement pour
#    lesquelles aucune option silencieuse n'a été utilisée
#    sont demandées interactivement.
#  - Pour chaque variable, sauf NOM_CONTENEUR_TOMCAT:
#		¤ une option silencieuse est utilisable, pour attribuer une valeur 
#		¤ si l'option silencieuse n'est pas utilisée, la valeur par défaut est appliquée si et ssi l'option --ask-me n'a pas été utilisée
# ---------------------------------------------------------
# [signature]
# ---------------------------------------------------------
#
# 	Cette fonction s'invoque sans aucun argument
#
# ---------------------------------------------------------


# traiter_args () {



# }



############################################################
############################################################
#					exécution des opérations			   #
############################################################
############################################################


export NOM_CONTENEUR_TOMCAT=ciblededeploiement-composant-srv-jee
export NOM_CONTENEUR_SGBDR=ciblededeploiement-composant-sgbdr

export ADRESSE_IP_SRV_JEE=192.168.1.63
export NUMERO_PORT_SRV_JEE=8888

export ADRESSE_IP_SGBDR=192.168.1.63
export NUMERO_PORT_SGBDR=3308

# clear
# echo " PAUSE DEBUG AVANT"
# read debug1

sudo sh lauriane/sys-setup.sh && sudo sh lauriane/installes-tout.sh
# clear
# echo " PAUSE DEBUG APRES"
# read debug2
# clear

