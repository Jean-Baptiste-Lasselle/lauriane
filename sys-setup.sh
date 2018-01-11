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


############################################################
############################################################
#					exécution des opérations			   #
############################################################
############################################################

# ==>> Mise à jour système
apt-get remove -y libappstream3
apt-get update -y

# ==>> Installation du serveur SSH
apt-get remove -y openssh-server
apt-get install -y openssh-server
clear
echo "Ne cherches pas à comprendre, presses la touche entrée pour réponse à toutes les questions (3 fois en tout)"

# Config accès SSH 
# Création d'un clé publique pour l'utilisateur $USER.
# la configuration par défaut de openssh-server implique
# que cette seule opération suffit à permettre l'accès
# ssh à l'utilisateur $USER. Sans utiliser la clé privée.
ssh-keygen -t rsa -b 4096



