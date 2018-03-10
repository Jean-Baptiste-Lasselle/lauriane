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



# DOCKER POSTGRESQL:  https://amattn.com/p/tutorial_postgresql_usage_examples_with_docker.html

# slick.dbs.default.db.url="jdbc:postgresql://127.0.0.1:5432/software-factory"


# ---------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------
# --------------------                	report code lauriane install SBT		                 ----------------------
# ---------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------



echo "That the installation begins!!"

# Install Java 

sudo apt-get update -y
sudo apt-get install -y default-jre
sudo apt-get install -y default-jdk

if type -p java; then
    echo Found java executable in PATH
    _java=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
    echo found java executable in JAVA_HOME     
    _java="$JAVA_HOME/bin/java"
else
    echo "Install Java..."
    sudo apt-get update -y
    sudo apt-get install -y default-jre
    sudo apt-get install -y default-jdk
   
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
        sudo apt-get install -y default-jre
        sudo apt-get install -y default-jdk
    fi
fi


# Install sbt

PKG_OK=$(dpkg-query -W --showformat='${Status}\n' sbt |grep "install ok installed")

echo "JIBL VERIFIE valeur PKG_OK=$PKG_OK"
if [ "" == "$PKG_OK" ]; then
    echo "Install sbt..."
    echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
    sudo apt-get update -y
    # sudo apt-get install -y sbt
	# j'ai trouvé sur le web: apparrement il n'y a pas de repo officiel SBT/ Ubuntu qui soit sécurisé correctement avec clé GPG
	# donc autant faire une installation en chintant l'authentification des packages.
    sudo apt-get install -y --allow-unauthenticated sbt
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



# sudo apt-get update
# heroku
# wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh

#postgresql
# sudo apt-get update -y
sudo apt-get install -y postgresql postgresql-contrib
sudo -i -u postgres createdb software_factory
sudo apt-get update -y

sudo -u postgres psql -c "ALTER USER postgres PASSWORD '123123';"
sudo -i -u postgres createdb software-factory --host=localhost --port=5432 --username=postgres

# export URI_REPO_GIT_CODE_SOURCE_APP_SCALA=https://github.com/Jean-Baptiste-Lasselle/siteweb-usinelogicielle.com
# on récupère le code source de l'application
# git clone https://github.com/laurianemollier/software-factory-website.git $REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT
git clone $URI_REPO_GIT_CODE_SOURCE_APP_SCALA $REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT

clear
# echo "Compile and run the website..."
# (cd "$PATH_SAMPLE" ;
    # sbt compile
    # sbt run
# )
echo " JIBL: version de Java "
java -version >> java.version
cat java.version
echo " JIBL: juste pour vérifier AVANT [cd $REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT].... REPERTOIRE COURANT: "
pwd
cd $REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT
echo " JIBL: juste pour vérifier APRES [cd $REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT].... REPERTOIRE COURANT: "
pwd
echo "Compile and run the website on dev mode..."
echo " JIBL: juste pour vérifier AVANT [sbt ~compile ~run].... REPERTOIRE COURANT: "
pwd
sbt ~compile ~run
echo " JIBL: juste pour vérifier APRES [sbt ~compile ~run].... REPERTOIRE COURANT: "
pwd
# (cd "$REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT" ;
    # echo " JIBL: juste pour vérifier provision-scala...."
    # sbt ~compile ~run
# )
