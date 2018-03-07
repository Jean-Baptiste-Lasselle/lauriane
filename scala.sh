###########################################################################################################################
###########################################################################################################################
###########################################################################################################################
###########################################################################################################################
###########################################################################################################################
###########################################################################################################################
# 
# AJOUT JIBL
# 
# Pour compatibilité Ubuntu 16.04 LTS
# 
# 
# 
# 
apt-get remove -y libappstream3
apt-get update -y && sudo apt-get upgrade -y && sudo apt-get update -y &&sudo apt-get autoremove -y
# installation Git
apt-get install -y git
# 
# 
# 
# 
# 
# 
# 
# 
###########################################################################################################################
###########################################################################################################################
###########################################################################################################################
###########################################################################################################################
###########################################################################################################################
###########################################################################################################################
#!/bin/bash


echo "That the installation begins!!"

# Install Java 

if type -p java; then
    echo Found java executable in PATH
    _java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
    echo found java executable in JAVA_HOME     
    _java="$JAVA_HOME/bin/java"
else
    echo "Install Java..."
    sudo apt-get update
    sudo apt-get -y install default-jre
    sudo apt-get -y install default-jdk
fi

if [[ "$_java" ]]; then
    version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    
    if [[ "$version" > "1.8.0_121" ]]; then
	clear
	echo "Java version $version is correclty installed"
    else         
        echo "Java should be at least of version 1.8.0_121 to continue the installation"
	echo "The actual version is $version"
        echo "Install Java..."
        sudo apt-get update
        sudo apt-get -y install default-jre
        sudo apt-get -y install default-jdk
    fi
fi


# Install sbt

PKG_OK=$(dpkg-query -W --showformat='${Status}\n' sbt |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
    echo "Install sbt..."
    echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
    sudo apt-get -y update
    sudo apt-get -y install sbt
    clear
else 
    echo "Sbt is already installed"
fi



PKG_OK=$(dpkg-query -W --showformat='${Status}\n' git |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
    echo "Install git..."
    sudo apt-get git
    clear
else
    echo "Git is already installed"
fi

git clone https://github.com/laurianemollier/software-factory-website.git

cd ./software-factory-website
# lancement du serveur scala et déploiement de l'application # à vérifier : je pense que le build de l'aplication est fait sur place
sbt run
