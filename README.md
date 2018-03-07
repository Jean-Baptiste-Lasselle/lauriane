# Résumé

Ce repo est documenté par ./ModdeDemploi.pdf, qui permet de monter des pipelines un peu particuliers...


# Pour utiliser `recette-provisionning-scala-env.sh`

## exécutez dans votre cible de déploiment 

* Un update de votre système:`sudo apt-get update -y`

* L'installation de git:`sudo apt-get install -y git`

## Exécutez ensuite `recette-provisionning-scala-env.sh`

Clonez le repo de référence de la recette, et exécutez-là:

* `git clone https://github.com/Jean-Baptiste-Lasselle/lauriane`
* `sudo chmod +x lauriane/recette-provisionning-scala-env.sh`
* `sudo lauriane/recette-provisionning-scala-env.sh`

## `recette-provisionning-scala-env.sh`, variables d'environnement:

Cette recette comporte deux varibles d'environneemnts dont la valeur est utilisées pour configurer le [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin)

* `MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME`  : définit le user linux qui sera utilsié par le [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin) pour opérer les déploiements scala.

* `REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT`  : définit dans quel répertoire L'application scala est déployée par le [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin) ? C'est dans ce répertoire que la commande st sera lancée.". Par défaut, le répertoire utilisé sera le répertoire /home/$MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME/provisionning-scala/software-factory-website"

