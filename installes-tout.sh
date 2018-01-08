# installation openssh
# sudo apt-get remove -y openssh-server
# sudo apt-get install -y openssh-server
clear
echo "ne cherches pas à comprendre, appuies 4 fois (comptes bien 4) sur Entrée pour continuer"
read

# ssh-keygen -t rsa -b 4096
# installation docker
sudo apt-get remove -y apt-transport-https ca-certificates curl software-properties-common
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg|sudo apt-key add -

# config repo docker

sudo apt-key fingerprint 0EBFCD88 >> ./VERIF-EMPREINTE-CLE-REPO.lauriane
# le fichier "./VERIF-EMPREINTE-CLE-REPO.lauriane" doit contenir:
# 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu" $(lsb_release -cs) stable



sudo apt-get update -y

sudo apt-get install -y docker-ce
