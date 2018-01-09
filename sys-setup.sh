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
	echo "Ce script a pour objet de configurer la machine sur";
	echo "laquelle vous allez expérimenter, de";
	echo "manière à rendre le déroulement de vos opérations le plus confortable possible.";
	echo "Vos expérimentations vont se faire dans une Machine Virtuelle Virtual Box.";
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


configurer_ip_statique () {

# VAR.
# ----

NOM_INTERFACE_RESEAU_A_RECONFIGURER_PAR_DEFAUT=enp0s3
NOM_INTERFACE_RESEAU_A_RECONFIGURER=$NOM_INTERFACE_RESEAU_A_RECONFIGURER_PAR_DEFAUT

# Gestion des valeurs passées en paramètre
# ----------------------------------------

NBARGS=$#

if [ $NBARGS -eq 0 ]
then
	echo "Quel est le nom de l'interface réseau linux que vous souhaitez reconfigurer?"
	echo "(l'interface utilisée par défaut sera : [$NOM_INTERFACE_RESEAU_A_RECONFIGURER]"
	read SAISIE_UTILISATEUR
else
	NOM_INTERFACE_RESEAU_A_RECONFIGURER=$1
fi

# confirmation nom interface réseau linux à reconfigurer 

echo "Vous confirmez vouloir re-configurer l'interface réseau linux : [$NOM_INTERFACE_RESEAU_A_RECONFIGURER] ?"
echo "Répondez par Oui ou Non (o/n). Répondre Non annulera toute configuration réseau."
read VOUSCONFIRMEZ
case "$VOUSCONFIRMEZ" in
	[oO] | [oO][uU][iI]) echo "L'interface réseau [$NOM_INTERFACE_RESEAU_A_RECONFIGURER] sera re-configurée" ;;
	[nN] | [nN][oO][nN]) echo "Aucune reconfiguration réseau ne sera faite.";return ;;
esac



# au boulot
# ----------
clear
echo "Quelle adresse IP voulez-vous pour cette machine?"
read FUTURE_ADRESSE_IP
echo "Quel masque de sous-réseau voulez-vous pour cette machine?"
read FUTUR_MASQUE_SOUS_RESEAU
echo "Quelle est l'adresse IP du routeur?"
read ADRESSE_IP_DU_ROUTEUR

sudo rm -f ./nvl-config-reseau
# sudo rm -f ./etc-ntwk-interfaces.bckup
sudo cp -f /etc/network/interfaces ./etc-ntwk-interfaces.bckup
cat /etc/network/interfaces >> ./nvl-config-reseau
echo "auto enp0s3" >> ./nvl-config-reseau
echo "iface enp0s3 inet static" >> ./nvl-config-reseau
echo "         address $FUTURE_ADRESSE_IP" >> ./nvl-config-reseau
echo "         netmask $FUTUR_MASQUE_SOUS_RESEAU" >> ./nvl-config-reseau
echo "         gateway $ADRESSE_IP_DU_ROUTEUR" >> ./nvl-config-reseau
echo "         dns-nameservers 8.8.8.8, 8.8.4.4" >> ./nvl-config-reseau

sudo rm -f /etc/network/interfaces
sudo cp ./nvl-config-reseau /etc/network/interfaces

# clear
# echo "Quand tu appuieras sur la touche entrée, la VM va redémarrer, attends qu'elle redémarre, puis continues avec la suite des instructions."
# read FIN
# sudo reboot -h now
sudo ip addr flush enp0s3
sudo systemctl restart networking.service

}



############################################################
############################################################
#					exécution des opérations			   #
############################################################
############################################################




# Possibilité de configuration réseau IP statique
clear
echo "Souhaitez-vous configurer une adresse IP statique pour cette machine? (oui/non)"
read DOIS_JE_CONFIG_IPSTATIQUE
case "$DOIS_JE_CONFIG_IPSTATIQUE" in
	[oO] | [oO][uU][iI]) configurer_ip_statique ;;
	[nN] | [nN][oO][nN]) echo "L'utilisateur $USER a répondu non: Aucune reconfiguration réseau ne sera donc faite.";;
	*) echo "L'utilisateur [$USER] a saisi une réponse incompréhensible: Aucune reconfiguration réseau ne sera donc faite.";;
esac


# ==>> Mise à jour système
sudo apt-get remove -y libappstream3
sudo apt-get update -y

# Installation du serveur SSH
sudo apt-get remove -y openssh-server
sudo apt-get install -y openssh-server
clear
echo "ne cherches pas à comprendre, appuies 4 fois (comptes bien 4) sur Entrée pour continuer"
read

# Config accès SSH 
# Création d'un clé publique pour l'utilisateur $USER.
# la configuration par défaut de openssh-server implique
# que cette seule opération suffit à permettre l'accès
# ssh à l'utilisateur $USER. Sans utiliser la clé privée.
ssh-keygen -t rsa -b 4096



