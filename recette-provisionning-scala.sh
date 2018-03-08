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

# export PROVISIONNING_HOME=$HOME/provisionning-scala
# à demander interactivement à l'utilisateur: "Quel utilisateur linux souhaitez-vous que le deployeur-maven-plugin utilise?"
# export MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME=lauriane
# à demander interactivement à l'utilisateur: "DAns quel répertoire souhaitez-vous que l'application scala soit déployée? C'est dans ce répertoire que la commande st sera lancée. [Par défaut, le répertoire utilsié sera le répertoire ..]:"
# export REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT=$HOME/software-factory-website

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
#
############################################################################################################################################################
# ################################   				Gestion des sudoers pour le deployeur-maven-plugin   					################################
############################################################################################################################################################
# TODO =>>> mettre à jour la configuration /etc/sudoers
rm -f $PROVISIONNING_HOME/sudoers.ajout
# export NOM_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN=lauriane-deploiement
# export URL_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN=https://github.com/Jean-Baptiste-Lasselle/lauriane-deploiement.git


echo "" >> $PROVISIONNING_HOME/sudoers.ajout
echo "# Allow DEPLOYEUR-MAVEN-PLUGIN to execute scala deployment commands" >> $PROVISIONNING_HOME/sudoers.ajout
echo "$MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME ALL=NOPASSWD: /bin/rm -rf $REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT" >> $PROVISIONNING_HOME/sudoers.ajout
echo "" >> $PROVISIONNING_HOME/sudoers.ajout
# echo "" >> $PROVISIONNING_HOME/lauriane/sudoers.ajout
clear
echo " --- Justez avaant de toucher /etc/sudoers:  "
echo "			" 
echo "			cat $PROVISIONNING_HOME/lauriane/sudoers.ajout" 
echo "			" 
echo " ---------------------------------------------------------------------------------------------------- "
cat $PROVISIONNING_HOME/sudoers.ajout
echo " ---------------------------------------------------------------------------------------------------- "
# echo " ---------	Pressez une touche pour ajouter en fin de /etc/sudoers 							------- "
# echo " ---------------------------------------------------------------------------------------------------- "
# read
# cat $MAISON/lauriane/sudoers.ajout >> /etc/sudoers
# echo 'foobar ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo

# MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME=lauriane
# MVN_PLUGIN_OPERATEUR_LINUX_USER_PWD=lauriane

# celui-ci marche, c'est testé:
cat $PROVISIONNING_HOME/sudoers.ajout | sudo EDITOR='tee -a' visudo

# clear
echo " ---------------------------------------------------------------------------------------------------- "
echo " --- De plus, l'utilisateur linux que votre plugin  "
echo " --- doit utiliser est: "
echo " --- 				 "
echo " --- 				nom d'utilisateur linux: $MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME"
echo " --- 				 "
echo " --- 				mot de passe: $MVN_PLUGIN_OPERATEUR_LINUX_USER_PWD"
echo " --- 				 "
echo " --- "
echo " --- "
echo " contenu du fichier         /etc/sudoers|grep $MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME       :"
cat /etc/sudoers|grep $MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME
echo " --- "
echo " --- "
echo " --- "
echo " ---------------------------------------------------------------------------------------------------- "
echo " ----------  Pressez une touche pour lancer le démarrage intiial de l'applciation Scala. "
echo " ---------------------------------------------------------------------------------------------------- "
read



git clone https://github.com/laurianemollier/ubuntu-script/ $PROVISIONNING_HOME/recettes-cible-deploiement
sudo chmod +x $PROVISIONNING_HOME/recettes-cible-deploiement/install-web-site.sh
sudo $PROVISIONNING_HOME/recettes-cible-deploiement/install-web-site.sh


# DOCKER POSTGRESQL:  https://amattn.com/p/tutorial_postgresql_usage_examples_with_docker.html

# slick.dbs.default.db.url="jdbc:postgresql://127.0.0.1:5432/software-factory"


# ---------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------
# --------------------                	report code lauriane isntall SBT		                 ----------------------
# ---------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------



echo "That the installation begins!!"

# Install Java 

sudo apt-get update
sudo apt-get -y install default-jre
sudo apt-get -y install default-jdk

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



#PKG_OK=$(dpkg-query -W --showformat='${Status}\n' git |grep "install ok installed")
#if [ "" == "$PKG_OK" ]; then
#    echo "Install git..."
#    sudo apt-get git
#    clear
#else
#    echo "Git is already installed"
#fi

git clone https://github.com/laurianemollier/software-factory-website.git


sudo apt-get update
# heroku
# wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh

#postgresql
sudo apt-get update
sudo apt-get install -y postgresql postgresql-contrib
sudo -i -u postgres createdb software_factory
sudo apt-get update

sudo -u postgres psql -c "ALTER USER postgres PASSWORD '123123';"
sudo -i -u postgres createdb software-factory --host=localhost --port=5432 --username=postgres


PATH_SAMPLE="software-factory-website"
mkdir "$PATH_SAMPLE"

clear
# echo "Compile and run the website..."
# (cd "$PATH_SAMPLE" ;
    # sbt compile
    # sbt run
# )
echo "Compile and run the website on dev mode..."
(cd "$PATH_SAMPLE" ;
    sbt ~compile ~run
)
