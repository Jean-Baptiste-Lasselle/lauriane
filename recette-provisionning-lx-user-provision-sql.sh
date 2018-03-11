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
############################################################################################################################################################
# ################################   				configuration SUDOERS: $USER_SQL_CREE_PAR_INSTALL_POSTGRE   			################################
# ################################   				Gestion des sudoers pour le deployeur-maven-plugin   					################################
# ################################   			  pour le goal "provision-scala" du deployeur-maven-plugin   				################################
############################################################################################################################################################
# TODO =>>> Pour l'utilisateur linux exécutant la recette de provision de la base de déonnées de l'application scala déployée, une configuration sudoers est
#           nécessaire, parce que certaines instructions de la recette de provision DOIVENT être exécutées avec sudo.
#           Par exemple, pour créer la BDD:
#           
#           sudo PGPASSWORD="$MDP_USER_SQL_CREE_PAR_INSTALL_POSTGRE" -i -u $USER_SQL_CREE_PAR_INSTALL_POSTGRE createdb $NOM_BDD --host=$HOSTNAME_BDD --port=$NO_PORT_BDD --username=$USER_SQL_CREE_PAR_INSTALL_POSTGRE --no-password
#           
rm -f $PROVISIONNING_HOME/sudoers.provision-sql-fullstack.ajout
echo "" >> $PROVISIONNING_HOME/sudoers.provision-sql-fullstack.ajout
echo "# Allow user [$USER_SQL_CREE_PAR_INSTALL_POSTGRE] to execute sql provisionning for scala apps" >> $PROVISIONNING_HOME/sudoers.provision-sql-fullstack.ajout

export CONFIG_SUDOERS_A_APPLIQUER=""
# la recette doit pouvoir crééer la BDD de l'application Scala, quelque soit son nom
CONFIG_SUDOERS_A_APPLIQUER="$CONFIG_SUDOERS_A_APPLIQUER/usr/lib/postgresql/$VERSION_POSTGRESQL/bin/createdb *"
# la recette doit pouvoir utiliser le client SQL de PostGreSQL, pour exécuter des requêtes SQL d'intialisation de la BDD.
CONFIG_SUDOERS_A_APPLIQUER="$CONFIG_SUDOERS_A_APPLIQUER, /usr/lib/postgresql/$VERSION_POSTGRESQL/bin/psql *"
# echo $CONFIG_SUDOERS_A_APPLIQUER
echo "$USER_SQL_CREE_PAR_INSTALL_POSTGRE ALL=NOPASSWD: $CONFIG_SUDOERS_A_APPLIQUER" >> $PROVISIONNING_HOME/sudoers.provision-sql-fullstack.ajout
echo "" >> $PROVISIONNING_HOME/sudoers.provision-sql-fullstack.ajout
# Log


echo " --- Juste avant d'appliquer la configuration sudoers à [$USER_SQL_CREE_PAR_INSTALL_POSTGRE]  "
echo "			" 
echo "			cat $PROVISIONNING_HOME/sudoers.provision-sql-fullstack.ajout" 
echo "			" 
echo " ---------------------------------------------------------------------------------------------------- "
cat $PROVISIONNING_HOME/sudoers.provision-sql-fullstack.ajout
echo " ---------------------------------------------------------------------------------------------------- "

# application config sudoers
cat $PROVISIONNING_HOME/sudoers.provision-sql-fullstack.ajout | sudo EDITOR='tee -a' visudo
