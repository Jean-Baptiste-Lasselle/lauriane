# Information

Ce repo est en cours de construction, pour constituer un support de formation en ligne.

# Résumé

Ce repo est documenté par ./ModdeDemploi.pdf, qui permet de monter des pipelines un peu particuliers...


# Pour utiliser `recette-provisionning-scala-env.sh`

## Exécutez dans votre cible de déploiment 

* Un update de votre système:`sudo apt-get update -y`

* L'installation de git:`sudo apt-get install -y git`

## Exécutez ensuite `recette-provisionning-scala-env.sh`

Clonez le repo de référence de la recette, et exécutez-là:

[comment]: <> `git clone https://github.com/Jean-Baptiste-Lasselle/lauriane`
[comment]: <> `sudo chmod +x lauriane/recette-provisionning-scala-env.sh`
[comment]: <> `sudo lauriane/recette-provisionning-scala-env.sh`

[comment]: <> * `export PROVISIONNING_HOME=$HOME/provisionning-scala`
[comment]: <> * `rm -rf $PROVISIONNING_HOME`
[comment]: <> * `mkdir -p $PROVISIONNING_HOME/recettes-operations`
[comment]: <> * `git clone https://github.com/Jean-Baptiste-Lasselle/lauriane $PROVISIONNING_HOME/recettes-operations`
[comment]: <> * `sudo chmod +x $PROVISIONNING_HOME/recettes-operations/monter-cible-deploiement-scala.sh`
[comment]: <> * `cd $PROVISIONNING_HOME/recettes-operations`
[comment]: <> * `./monter-cible-deploiement-scala.sh`

```
export PROVISIONNING_HOME=$HOME/provisionning-scala
rm -rf $PROVISIONNING_HOME
mkdir -p $PROVISIONNING_HOME/recettes-operations
git clone https://github.com/Jean-Baptiste-Lasselle/lauriane $PROVISIONNING_HOME/recettes-operations
sudo chmod +x $PROVISIONNING_HOME/recettes-operations/monter-cible-deploiement-scala.sh
cd $PROVISIONNING_HOME/recettes-operations
./monter-cible-deploiement-scala.sh
```

## Variables d'environnement

Cette recette comporte deux varibles d'environnements dont la valeur est utilisées pour configurer le [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin)

Vous pouvez vous inspirer de cet [exemple de configuration du pom.xml](https://github.com/Jean-Baptiste-Lasselle/mavenisation-siteweb-usinelogicielle), permettant d'utiliser  le [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin) sur un pipeline Scala.


* `MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME`  : définit le user linux qui sera utilisé par le [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin) pour opérer les déploiements scala. Cette variable d'environnement est liée au paramètre de configuration "`<ops-lx-user>leuserlinuxquevousavezcréé</ops-lx-user>`" du [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin).

* `REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT`  : définit dans quel répertoire L'application scala est déployée par le [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin) ? C'est dans ce répertoire que la commande st sera lancée.". Par défaut, le répertoire utilisé sera le répertoire /home/$MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME/provisionning-scala/software-factory-website". Cette variable d'environnement est liée au paramètre de configuration "`<repertoire-deploiement-scala>/chemin/de/repertoire/de/votre/choix</repertoire-deploiement-scala>`" du [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin).

## TODOs

* Faire un archetype maven pour le type de projet maven-scala, avec dedans une configuration typique du pom.xml, en remplacement de l'[exemple de configuration du pom.xml](https://github.com/Jean-Baptiste-Lasselle/mavenisation-siteweb-usinelogicielle)
