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
sudo apt-get remove -y apt-transport-https ca-certificates curl software-properties-common
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg|sudo apt-key add -

# config repo ubuntu contenant les dépendances docker
sudo apt-key fingerprint 0EBFCD88 >> ./VERIF-EMPREINTE-CLE-REPO.lauriane
# le fichier "./VERIF-EMPREINTE-CLE-REPO.lauriane" doit contenir:
# 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"



sudo apt-get update -y

sudo apt-get install -y docker-ce

sudo usermod -aG docker $USER

sudo systemctl enable docker
sudo systemctl start docker

##########################################################
##### MONTEE INFRASTRUCTURE CIBLE DE DEPLOIEMENT #########
##########################################################
# construction d'un conteneur tomcat 
#
NOM_CONTENEUR_TOMCAT=ciblededeploiement-composant-srv-jee
NUMERO_PORT_SRV_JEE=8888
clear
echo "Quand tu appuieras sur Entrée, attends quelque secondes, et ton serveur tomcat sera accessible à:"
echo "		http://adressIP-detaVM:8888/"
echo "Quand tu veux."
read
sudo docker run -it --name $NOM_CONTENEUR_TOMCAT --rm -p $NUMERO_PORT_SRV_JEE:8080 tomcat:8.0
# http://adressIP:8888/