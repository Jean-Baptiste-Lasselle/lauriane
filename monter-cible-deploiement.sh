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
#			Variables d'environnement globales		 	   #
############################################################
############################################################

NOM_CONTENEUR_TOMCAT=ciblededeploiement-composant-srv-jee
NOM_CONTENEUR_SGBDR=ciblededeploiement-composant-sgbdr

ADRESSE_IP_SRV_JEE=192.168.1.63
NUMERO_PORT_SRV_JEE=8888

ADRESSE_IP_SGBDR=192.168.1.63
NUMERO_PORT_SGBDR=3308


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

determiner_addr_ip_initiale_machine () {

	echo "Quelle est l'adresse IP de cette machine?"
	echo "Voici qui peut vous aider à trouver cette adresse:"
	echo " "
	ip addr|grep "inet"|grep -v "inet6"|grep "enp\|wlan"
	echo " "
	read ADRESSE_IP_DE_CETTE_MACHINE
	ADRESSE_IP_SRV_JEE=$ADRESSE_IP_DE_CETTE_MACHINE
}

demander_choix_no_ports () {

	echo "Quel nuéméro de port souhaitez-vous que le serveur jee utilise?"
	read SAISIE_NUMERO_PORT_SRV_JEE
	
	echo "Quel nuéméro de port souhaitez-vous que le SGBDR utilise?"
	read SAISIE_NUMERO_PORT_SGBDR
	
	
	
}


############################################################
############################################################
#					exécution des opérations			   #
############################################################
############################################################




determiner_addr_ip_initiale_machine
demander_choix_no_ports

export NOM_CONTENEUR_TOMCAT
export NOM_CONTENEUR_SGBDR

export ADRESSE_IP_SRV_JEE
NUMERO_PORT_SRV_JEE=$SAISIE_NUMERO_PORT_SRV_JEE
export NUMERO_PORT_SRV_JEE

export ADRESSE_IP_SGBDR
NUMERO_PORT_SGBDR=$SAISIE_NUMERO_PORT_SGBDR
export NUMERO_PORT_SGBDR

clear
echo POIN DEBUG FIN
echo "verif valeur [ADRESSE_IP_SRV_JEE=$ADRESSE_IP_SRV_JEE]"
echo "verif valeur [NUMERO_PORT_SRV_JEE=$NUMERO_PORT_SRV_JEE]"
echo "verif valeur [NUMERO_PORT_SGBDR=$NUMERO_PORT_SGBDR]"
read


sudo chmod +x lauriane/*.sh

lauriane/sys-setup.sh && lauriane/generer-op-std-deploiement.sh && lauriane/installes-tout.sh