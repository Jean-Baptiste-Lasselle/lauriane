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

export PROVISIONNING_HOME=$HOME/provisionning-scala
# à demander interactivement à l'utilisateur: "Quel utilisateur linux souhaitez-vous que le deployeur-maven-plugin utilise?"
export MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME=lauriane
# Ce nom d'utilisateur linux est utilisé pour la provision scala, et pour sa configuration sudoers cf. [monter-cible-deploiement-scala.sh]
export USER_SQL_CREE_PAR_INSTALL_POSTGRE=postgres

# création des répertoires de travail pour le provisionning => doivent exister...
rm -rf $PROVISIONNING_HOME
mkdir -p $PROVISIONNING_HOME
# rm -rf $PROVISIONNING_HOME/recettes-cible-deploiement
# mkdir -p $PROVISIONNING_HOME/recettes-cible-deploiement

# à l'opérateur: Mises à jour système de la LTS, avant début des opérations - nepeut être versionné synchrone avec le versionning d'une recette de déploiement

export VERSION_POSTGRESQL=9.5

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
# 
cd $PROVISIONNING_HOME

# TODO: Création de l'utilisateur linux $MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME

############################################################################################################################################################
# ################################   				configuration SUDOERS: $MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME			################################
# ################################   				Gestion des sudoers pour le deployeur-maven-plugin   					################################
# ################################   			  pour le goal "provision-scala" du deployeur-maven-plugin   				################################
############################################################################################################################################################
# TODO =>>> Pour l'utilisateur linux exécutant la provision scala, une configuration sudoers est
#           nécessaire, parce que certaines instructions de la recette DOIVENT être
#           exécutées avec sudo.

# - Liste des commandes qui doivent être exécutées avec sudo dans la recette
# 			SCALA
# 			sudo apt-get update -y
# 			sudo apt-get -y install default-jre
# 			sudo apt-get -y install default-jdk
# 			sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
# 			sudo apt-get install -y sbt
# 			POSTGRESQL
# 			sudo apt-get install -y postgresql postgresql-contrib
# 			sudo -i -u postgres createdb software_factory
# 			sudo apt-get update -y
# 			sudo -u postgres psql -c "ALTER USER postgres PASSWORD '123123';"
# 			sudo -i -u postgres createdb software-factory --host=localhost --port=5432 --username=postgres
# 
# - Liste config sudoers inférée
# 		+ /usr/sbin/visudo
# 		+ /bin/cat /etc/sudoers
# 		+ /usr/bin/apt-get update -y
# 		+ /usr/bin/apt-get install -y default-jre
# 		+ /usr/bin/apt-get install -y default-jdk
# 		+ /usr/bin/apt-get adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
# 		+ /usr/bin/apt-get install -y sbt
# 		+ /usr/bin/apt-get install -y postgresql postgresql-contrib
# 		+ /usr/lib/postgresql/9.5/bin/postgres createdb *
# 		+ /usr/lib/postgresql/9.5/bin/psql *
# 
# 
# 

rm -f $PROVISIONNING_HOME/sudoers.provision-scala-fullstack.ajout
# export NOM_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN=lauriane-deploiement
# export URL_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN=https://github.com/Jean-Baptiste-Lasselle/lauriane-deploiement.git


echo "" >> $PROVISIONNING_HOME/sudoers.provision-scala-fullstack.ajout
echo "# Allow DEPLOYEUR-MAVEN-PLUGIN's operator [$MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME] to execute scala deployment commands" >> $PROVISIONNING_HOME/sudoers.provision-scala-fullstack.ajout

export CONFIG_SUDOERS_A_APPLIQUER=""
# la recette doit pouvoir configurer des sudoers
CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER"/usr/sbin/visudo *"
CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER", /bin/cat /etc/sudoers"
# la recette doit pouvoir mettre à jour le système
CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER", /usr/bin/apt-get update -y"
# la recette doit pouvoir installer le JAVA JDK
CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER", /usr/bin/apt-get install -y default-jre"
CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER", /usr/bin/apt-get install -y default-jdk"
# la recette doit pouvoir configurer des clés de repository ubuntu pour apt-key:
# CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER", /usr/bin/apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823"
CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER", /usr/bin/apt-key *"
# la recette doit pouvoir installer SBT
CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER", /usr/bin/apt-get install -y sbt"
CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER", /usr/bin/apt-get install -y --allow-unauthenticated sbt"
# la recette doit pouvoir installer PostGreSQL
CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER", /usr/bin/apt-get install -y postgresql postgresql-contrib"
# la recette doit pouvoir crééer la BDD de l'application Scala, quelque soit son nom
# CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER", /usr/lib/postgresql/$VERSION_POSTGRESQL/bin/postgres createdb *"
CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER", /usr/lib/postgresql/$VERSION_POSTGRESQL/bin/createdb *"
# la recette doit pouvoir utiliser le client SQL de PostGreSQL, pour exécuter des requêtes SQL d'intialisation de la BDD.
CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER", /usr/lib/postgresql/$VERSION_POSTGRESQL/bin/psql *"
# la recette de provision scala doit pouvoir configurer des repository pour APT-GET
CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER", /usr/bin/tee -a /etc/apt/sources.list.d/sbt.list"
# CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER", /usr/bin/tee -a /etc/sudoers"
# CONFIG_SUDOERS_A_APPLIQUER=$CONFIG_SUDOERS_A_APPLIQUER", /usr/bin/tee *"

echo "$MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME ALL=NOPASSWD:SETENV: $CONFIG_SUDOERS_A_APPLIQUER" >> $PROVISIONNING_HOME/sudoers.provision-scala-fullstack.ajout
echo "" >> $PROVISIONNING_HOME/sudoers.provision-scala-fullstack.ajout

echo " --- Juste avant d'appliquer la configuration sudoers à [$MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME]  "
echo "			" 
echo "			cat $PROVISIONNING_HOME/sudoers.provision-scala-fullstack.ajout" 
echo "			" 
echo " ---------------------------------------------------------------------------------------------------- "
cat $PROVISIONNING_HOME/sudoers.provision-scala-fullstack.ajout
echo " ---------------------------------------------------------------------------------------------------- "

# celui-ci marche, c'est testé:
cat $PROVISIONNING_HOME/sudoers.provision-scala-fullstack.ajout | sudo EDITOR='tee -a' visudo
