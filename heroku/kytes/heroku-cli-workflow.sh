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
# ¤ [TEST-KO]
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
# -- https://devcenter.heroku.com/articles/getting-started-with-scala
############################################################
# à partir de la ligne suivante, toute ligne qui commence
# par "# ", est une commadne linux exécutable si onla dé-commente.
############################################################
############################################################
############################################################
# -- 			environnement des opérations			 --#
############################################################
############################################################
export NOM_APPLICATION_HEROKU=kytes-public-pr-endpoint
export NOM_FICHIER_APPLICATION_PACKAGEE=$NOM_APPLICATION_HEROKU
# -- =============>>>>>>>> Ce script prend en premier argument:
# -- la liste des arguments à passer à l'exécution de
# -- l'application scala déployée.
# -- Les arguments ainsi passés ne doivent pas être paramétrés
# -- par l'environnement Heroku, comme par exemple:
# -- 	-Dhttp.port=${PORT}   =>   c'est une variable propre aux environnements Heroku

export LISTE_ARGUMENTS_EXECUTION_SCALA_APP=""
# les paramèteres que je peux passer en argument de ce script 
export LISTE_ARGUMENTS_EXECUTION_SCALA_APP_SANS_PARAMETRES_HEROKU=""
for i in {0..$#}
do
    LISTE_ARGUMENTS_EXECUTION_SCALA_APP_SANS_PARAMETRES_HEROKU=$LISTE_ARGUMENTS_EXECUTION_SCALA_APP_SANS_PARAMETRES_HEROKU" $i"
done
# -- les paramètres que je suis préfère passer en dur dans le
# -- code source de cette recette, quelle qu'en soit la raison.
export LISTE_ARGUMENTS_EXECUTION_SCALA_APP_AVEC_PARAMETRES_HEROKU="-Dhttp.port=${PORT} -Ddb.default.url=${DATABASE_URL}"
LISTE_ARGUMENTS_EXECUTION_SCALA_APP=$LISTE_ARGUMENTS_EXECUTION_SCALA_APP_SANS_PARAMETRES_HEROKU" "$LISTE_ARGUMENTS_EXECUTION_SCALA_APP_AVEC_PARAMETRES_HEROKU

export TIMESTAMPUNIQUE=$(date +\"%d-%m-%Y-%HHeures%Mmin%SSec\")
export OPERATIONS_HOME=$HOME/heroku-production/ops/$TIMESTAMPUNIQUE
export REPERTOIRE_OP_GIT=$OPERATIONS_HOME/source-initial
export REPERTOIRE_OP_SUR_CODE_SRC=$OPERATIONS_HOME/manips-code-source
# export REPERTOIRE_DEPLOIEMENT_APP_SCALA='$HOME/kytes-public-relations'
export URI_REPO_CODE_SOURCE=https://github.com/Jean-Baptiste-Lasselle/siteweb-usinelogicielle.com
# mkdir -p $OPERATIONS_HOME
mkdir -p $REPERTOIRE_OP_GIT
mkdir -p $REPERTOIRE_OP_SUR_CODE_SRC


# -- 
# -- Pour le cas où je souhaite que le client Heroku 
# -- utilise un proxy HTTP ou HTTPS 
# -- 
# export HTTP_PROXY=http://adresseIPdeMONproxyHTTP:portnumber
# export HTTPS_PROXY=http://adresseIPdeMONproxyHTTPS:portnumber

############################################################
############################################################
# --    			exécution des opérations		    -- #
############################################################
############################################################
# 
# -- Il s'agit de d'automatiser les opérations standard du
# -- cycle de développement d'une application de type scala website,
#
# -- Avec cette automatisation, je créérai un nouveau module Kytes: `kytes-pr`
# -- Lorsque l'on gère le cyle de vie d'une application avec kytes, dans
# -- la ligne de production, `kytes-pr` permet d'automatiser la gestion
# -- des publications du site web publié pour communiquer sur l'application
# 
# -- Kytes utilsiera `kytes-pr` pour gérer les comunications publiées sur le site web du projet https://kytes.io
# 
# -- 
# -- le client Heroku fait usage de Git
# -- 
# -- Installation Git
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' git |grep "install ok installed")
if [ "" == "$PKG_OK" ]; then
   echo "Installing git..."
   sudo apt-get git
   clear
else
   echo "Git is already installed"
fi
echo "Proceeding with operations flow..."
# -- installation du client heroku
wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh
chmod +x ./install-ubuntu.sh
 ./install-ubuntu.sh
 
# -- authentification interactive
heroku login

############################# INITIALISATION PROJET
############################# INITIALISATION PROJET
############################# INITIALISATION PROJET
############################# INITIALISATION PROJET
############################# 
############################# Il faut créer le projet Heroku, et faire un premier déploiement du code source importé du repo Git "$URI_REPO_CODE_SOURCE"
############################# 
############################# 
# -- récupération initiale code source application
git clone "$URI_REPO_CODE_SOURCE" $REPERTOIRE_OP_GIT

# -- on travaillera sur une copie de la version récupérée, on
# -- ne modifie pas directement la version récupérée initialement.
cp -rf $REPERTOIRE_OP_GIT/* $REPERTOIRE_OP_SUR_CODE_SRC

cd $REPERTOIRE_OP_SUR_CODE_SRC
# -- 
# -- On doit "créer un projet heroku", qui
# -- représente notre application, chez Heroku, dans notre compte.
# -- On peut donc certainement créer plusieurs projets pour un même compte Heroku.
# -- 
# -- La commande `heroku-create` génère un nom randomisé pour l'application, mais
# -- on peut fixer ce nom en le passant en paramètre de la commande `heroku create`
heroku create $NOM_APPLICATION_HEROKU

# -- 
# J'ajoute un fichier Procfile en me débarassant de l'éventuel existant.
# -- 
rm -f ./Procfile
echo "# kytes public relations' endpoint deployment procedure." >> ./Procfile
# le Procfile a une syntaxe spécifique, je ne peux utiliser les commandes /bin/bash
echo "# kytes public relations' endpoint ne nécessite qu'un seul process (dyno), de type web: c'est un site web vitrine du projet" >> ./Procfile
echo "web: target/universal/stage/bin/$NOM_FICHIER_APPLICATION_PACKAGEE $LISTE_ARGUMENTS_EXECUTION_SCALA_APP" >> ./Procfile
# echo "web: target/universal/stage/bin/software-factory -Dhttp.port=${PORT} -Dplay.evolutions.db.default.autoApply=true -Ddb.default.driver=org.postgresql.Driver -Ddb.default.url=${DATABASE_URL}" >> ./Procfile
# echo "console: target/universal/stage/bin/play-getting-started -main scala.tools.nsc.MainGenericRunner -usejavacp" >> ./Procfile

# -- version scriptée /bin/bash, dépréciée pour Heroku
# echo "rm -rf -p $REPERTOIRE_DEPLOIEMENT_APP_SCALA" >> ./Procfile
# echo "mkdir -p $REPERTOIRE_DEPLOIEMENT_APP_SCALA" >> ./Procfile
# echo "# package" >> ./Procfile
# echo "sbt dist" >> ./Procfile
# echo "cp -rf ./target/universal/stage/* $REPERTOIRE_DEPLOIEMENT_APP_SCALA" >> ./Procfile
# echo "# run" >> ./Procfile
# echo "$REPERTOIRE_DEPLOIEMENT_APP_SCALA/bin/$NOM_FICHIER_APPLICATION_PACKAGEE $LISTE_ARGUMENTS_EXECUTION_SCALA_APP" >> ./Procfile




# -- Là en fait j'ai un problème: comment faire pour ajouter ce nouveau fichier dans le remote  
git add Procfile
git commit -m 'Ajout du Procfile Heroku, par `kytes-pr`, pour définir la procédure de déploiement de l application dans instance Heroku '
git tag deploiement-initial-$NOM_APPLICATION_HEROKU-$TIMESTAMPUNIQUE -m "deploiement-initial-[$NOM_APPLICATION_HEROKU]-[$TIMESTAMPUNIQUE] L'application déployée est exactement la dernière versiond ela branche master dans le repo git [$URI_REPO_CODE_SOURCE] "
# -- es-ce que ça fera le commit & push vers [$URI_REPO_CODE_SOURCE]? TODO: à vérifier.
git push master && git push --tags master
# -- Et maintneant, on peut déployer l'application UNE PREMIERE FOIS chez Heroku
git push heroku master && git push --tags heroku master



# - exemple de sortie standard de cette commande:
# -- Creating nameless-lake-8055 in organization heroku... done, stack is cedar-14
# -- http://nameless-lake-8055.herokuapp.com/ | https://git.heroku.com/nameless-lake-8055.git
# -- Git remote heroku added

# -- La commande `heroku-create` créée un repo git remote dans les infrastructures Heroku.
# -- et ce remote git repo est automatiquement associé au repo git local trouvé dans  $REPERTOIRE_OP_SUR_CODE_SRC :
# -- Donc, après la commande  `heroku-create`, le remote origin n'est plus [$URI_REPO_CODE_SOURCE], mais [le git remote "heroku" créé dans l'infrastructure Heroku, par la commande `heroku-create`]


# ##############  EDITER LE CODE SOURCE DE L'APPLICATION
# -- Pour préciser à Heroku les commandes à exécuter au déploiement de l'application, on


# ##############  EDITER LE ./build.sbt && ./project/plugins.sbt
# -- J'y ajoute les dépendances nécessaires pour le plugin [sbt-native-packager]
echo ' ' >> ./project/plugins.sbt
echo 'addSbtPlugin("com.typesafe.sbt" % "sbt-native-packager" % "1.3.2")' >> ./project/plugins.sbt

# -- Là en fait j'ai un problème: comment faire pour ajouter ce nouveau fichier dans le remote  
git add ./build.sbt && git add ./project/plugins.sbt
# git commit -m "Modification des fichiers ./build.sbt && git ./project/plugins.sbt, par `kytes-pr`, pour définir la procédure de build de l'application "
# git tag build-$NOM_APPLICATION_HEROKU-$TIMESTAMPUNIQUE -m "build-[$NOM_APPLICATION_HEROKU]-[$TIMESTAMPUNIQUE] Modification des fichiers build.sbt et ./project/plugins.sbt, par [kytes-pr], pour définir la procédure de build  de l'application [$NOM_APPLICATION_HEROKU]"
# -- Et maintneant, on peut builder l'application en une seule commande
sbt dist

# ##############  PROCFILE
# -- Pour préciser à Heroku les commandes à exécuter au déploiement de l'application, on
# -- doit les spécifier dans un ficheir de nom "Procfile", à la racine du
# -- projet git dans lequel on a fait le `heroku login`

rm -f ./Procfile
echo "# kytes public relations' endpoint deployment procedure." >> ./Procfile
# -- le Procfile a une syntaxe spécifique, je ne peux utiliser les commandes /bin/bash
echo "# kytes public relations' endpoint ne nécessite qu'un seul process (dyno), de type web: c'est un site web vitrine du projet" >> ./Procfile


echo "web: target/universal/stage/bin/$NOM_FICHIER_APPLICATION_PACKAGEE $LISTE_ARGUMENTS_EXECUTION_SCALA_APP" >> ./Procfile
# echo "web: target/universal/stage/bin/software-factory -Dhttp.port=${PORT} -Dplay.evolutions.db.default.autoApply=true -Ddb.default.driver=org.postgresql.Driver -Ddb.default.url=${DATABASE_URL}" >> ./Procfile
# echo "console: target/universal/stage/bin/play-getting-started -main scala.tools.nsc.MainGenericRunner -usejavacp" >> ./Procfile

# -- version scriptée /bin/bash, dépréciée pour Heroku
# echo "rm -rf -p $REPERTOIRE_DEPLOIEMENT_APP_SCALA" >> ./Procfile
# echo "mkdir -p $REPERTOIRE_DEPLOIEMENT_APP_SCALA" >> ./Procfile
# echo "# package" >> ./Procfile
# echo "sbt dist" >> ./Procfile
# echo "cp -rf ./target/universal/stage/* $REPERTOIRE_DEPLOIEMENT_APP_SCALA" >> ./Procfile
# echo "# run" >> ./Procfile
# echo "$REPERTOIRE_DEPLOIEMENT_APP_SCALA/bin/$NOM_FICHIER_APPLICATION_PACKAGEE $LISTE_ARGUMENTS_EXECUTION_SCALA_APP" >> ./Procfile



# ##############  RE-DEPLOIEMENT
# -- on met à jour le timestamp
TIMESTAMPUNIQUE=$(date +\"%d-%m-%Y-%HHeures%Mmin%SSec\")
# -- 
# -- Je versionne les fichiers modifiés
git add Procfile ./build.sbt ./project/plugins.sbt */* */*.*
git commit -m 'Ajout du Procfile Heroku, par `kytes-pr`, pour définir la procédure de déploiement de l application dans instance Heroku '
git tag deploiement-$NOM_APPLICATION_HEROKU-$TIMESTAMPUNIQUE -m "deploiement-[$NOM_APPLICATION_HEROKU]-[$TIMESTAMPUNIQUE] Fichiers de configuration de build modifiés:[] Procfile Heroku, par [kytes-pr], pour définir la procédure de déploiement de l'application dans l'instance Heroku "
# -- Et maintneant, on peut déployer l'application en une seule commande
git push heroku master && git push --tags heroku master
# -- es-ce que le git tag va être pris en compte? TODO ==>> à vérifier dans les tests.
# -- Conclusion: on n'a a aucun moment précisé d'adresse IP de nom de domaine pour une cible de déploiement, 

# -- La commande `heroku open` permet d'accéder directement à l'applciation (sans connaître d'URL).
# heroku open





# ##############  SCALE UP/DOWN
# -- Aficher le statut des "dynos" (unité de scale up chez Heroku)
heroku ps
# -- Il n'y a aucun service (0 "dynos"), je dois obtenir une erreur avec `heroku open`
heroku ps:scale web=0
# -- Je fais un premier scale up: Il y a un service (1 "dynos"), je dois obtenir une réponse OK de mon application Scala avec `heroku open`
heroku ps:scale web=1









# ##############  LOGGING
# -- La commande `heroku logs --tail` permet de rediriger le flux des logs de l'application en
# -- cours d'exécution (dans l'infrastructure Heroku) vers la sortie standard de cette machine:
# heroku logs --tail
# -- Pour réaliser cette redirection de logs, le client Heroku utilise [l'API Logplex](https://github.com/heroku/logplex)
# -- TODO: Dans kytes, permettre la supervision d'une l'application déployée chez Heroku, en utilisant l'API logplex, comme le client, et en faisant de l'output de cube-logplex sur Kibana
# -- TODO: Dans Kytes, faire en sorte que les cible de déploiement puissent être supervisées par une alternative de cube-logplex (avec analyse "time-series", et routeur distribué de logs). [Les meileurs packages de logging que j'ai vu, c'est du Logstash / Kibana, avec analyses en times series par un moteur affublé de capacité de machine-learning. ça ne devrait pas être très difficile à remonter.]
# -- Première alternative à essayer: ELK http://linuxfr.org/news/gestion-des-logs-avec-logstash-elasticsearch-kibana + https://logz.io/learn/complete-guide-elk-stack/

# -- La commande `heroku logs --tail` comprend plusieurs options intéressantes:
# -- pour visualiser les logs de l'application uniquement
# heroku logs --tail --source app
# -- pour visualiser les logs système uniquement
# heroku logs --tail --source heroku
# -- pour leslogs de l'API Heroku (utilisée par le client):
# -- permet notamment de superviser l'activité de tous les
# -- développeurs sur cette instance de projet Heroku.
# heroku logs --tail --source app --dyno api


# -- Heroku offre des services additionnels payants pour le logging, et chacun de ces
# -- services (payants?) peut être utilisés avec des options spécifiques et
# -- documentées pour chaque service.
# heroku logs --tail autres_options_specifiques_a_chaque_service_additionnel
# -- >>>>> les services offerts sont du genre Logstash / Kibana. // 


# ##############  ONE-OFF DYNO : pour exécuter des commandes dans le conteneur Heroku
# -- You can run a command, typically scripts and applications that are
# -- part of your app, in a one-off dyno using the heroku run command.
# -- It can also be used to launch a console process attached to your local terminal for
# -- experimenting in your app’s environment, or code that you deployed with your application:
# heroku run console


# ##############  TODO: voir les "config vars" ... pas sûr que ce me soit très utile, dans la mesure où il faut modifier le code source.
# -- https://devcenter.heroku.com/articles/getting-started-with-scala#define-config-vars
# -- =>> sert notamment pour paramétrer l'application pourles différentes cibles de déploiement: dev, integration preprod, prod
# -- affiche toutes les varibles de la configuration
# heroku config
# -- permet de définir une variable dans la configuration, et de fixer sa valeur
# heroku config:set NOM_DE_MA_VARIABLE=asie
# -- permet de supprimer la définition d'une variable dans la configuration
# heroku config:unset NOM_DE_MA_VARIABLE
# -- permet d'obtenir la valeur d'une variable particulière.
# heroku config:get NOM_DE_MA_VARIABLE
# -- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> OK LES VARIABLES UTILISEES DANS LE Procfile  SONT CELLES DISPONIBLES DANS CETTE CONFIGURATION


# ##############  ADD-ONS : 
# -- Okay, donc en fait la notion de "add-on" Heroku, c'est pour rajouter des dépendances à la cible de déplooiement Heroku.
# -- Par exemple, il faut ajouter un add-on, pour pouvoir utilsier une BDD, ou un service Logstash, dans un cible de déploiement Heroku..
# -- Il y a donc des petites notions de packaging à mettre au clair pour les addons (dans quel(s) ficheir(s) de configuration précise-t-on les add-ons à ajouter à la cible de déploiement?
# -- le client HEROKU va chercher les add-ons dans un rrepository distant qu'éHeroku appelle "marketplace"
# -- Reste à tester s'il y a bien des add-ons qu'on peut utiliser gratuitement.

# ##############  TODO: utiliser une base de données ds la cible de déploiement Heroku
# -- 
# -- 
# -- 
# -- 




# #############      REST API CLIENT HEROKU
# -- 
# -- Je vais pouvoir faire tout ce que je fais dans ce script, à
# -- l'aide de la REST API Heroku: https://devcenter.heroku.com/articles/platform-api-quickstart
# -- 