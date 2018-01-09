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



# installation docker
sudo apt-get remove -y apt-transport-https ca-certificates curl software-properties-common
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg|sudo apt-key add -

# config repo docker

sudo apt-key fingerprint 0EBFCD88 >> ./VERIF-EMPREINTE-CLE-REPO.lauriane
# le fichier "./VERIF-EMPREINTE-CLE-REPO.lauriane" doit contenir:
# 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"



sudo apt-get update -y

sudo apt-get install -y docker-ce

sudo usermod -aG docker $USER

sudo systemctl enable docker
sudo systemctl start docker