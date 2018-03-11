# Information

Ce repo est en cours de construction, pour constituer un support de formation en ligne.

# Résumé

Ce repo est documenté par ./ModdeDemploi.pdf, qui permet de monter des pipelines un peu particuliers...


# Pour développer une application Scala

## Mettez votre cible de déploiement dans son état initial

Pour mettre votre cible de déploiement dans son état initial, vous allez réaliser
des opérations dans votre cible de déploiement à l'aide d'un utilisateur linux.
À l'issue de ces opérations, votre cible de déploiement:
* sera prête à recevoir le déploiement d'une application Scala. 
* offrira à toute application Scala déployée en son sein, la possibilité de faire usage d'une base de données PostGReSQL.

Etant donné les opérations à réaliser, cet utilisateur linux devra
être administrateur: il doit pouvoir exécuter des commandes shell avec sudo.
Vous pourriez créer un tel utilisateur avec les commandes suivantes:

```
export NOM_DU_FUTUR_UTILISATEUR_LINUX=scala-provisioner
# cette commande vous demandera une saisie interactive, exécutez-là séparément de la commande suivante.
adduser $NOM_UTILISATEUR_LINUX_PROVISION_SCALA
# puis lorsque vous avez terminé les saisies interactives exigées
# par la commande précédente, exécutez:
usermod -aG sudo $NOM_UTILISATEUR_LINUX_PROVISION_SCALA
```

Exécutez ensuite:
* Un update de votre système:`sudo apt-get update -y`
* Une installation d'un serveur SSH :`sudo apt-get install -y openssh-server`
* L'installation de git:`sudo apt-get install -y git`

Avec l'utilisateur linux `$NOM_UTILISATEUR_LINUX_PROVISION_SCALA`, exécutez:

## Exécutez ensuite `recette-provisionning-scala-env.sh`

### Première possibilité: Clonez le repo de référence de la recette, et exécutez-là

* Mettez votre cible de déploiement dans son état initial: Update systèmes, openSSH et Git installés.
* puis exécutez les commandes suivantes:
```
# l'URI du repo git du code source de l'application scala qui sera déployée initialement
export URI_REPO_GIT_CODE_SOURCE_APP_SCALA=http://nomdedomaineouip:noport/chemin/vers/repo
export PROVISIONNING_HOME=$HOME/provisionning-scala
rm -rf $PROVISIONNING_HOME
mkdir -p $PROVISIONNING_HOME/recettes-operations
git clone https://github.com/Jean-Baptiste-Lasselle/lauriane $PROVISIONNING_HOME/recettes-operations
sudo chmod +x $PROVISIONNING_HOME/recettes-operations/monter-cible-deploiement-scala.sh
cd $PROVISIONNING_HOME/recettes-operations
./monter-cible-deploiement-scala.sh $URI_REPO_GIT_CODE_SOURCE_APP_SCALA
```

### Deuxième possibilité: Utilisez le [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin)

* Mettez votre cible de déploiement dans son état initial: Update systèmes, openSSH et Git installés, et 
* Avec un utilisateur linux administrateur (`$NOM_UTILISATEUR_LINUX_PROVISION_SCALA`), exécutez:
```
curl -O https://raw.githubusercontent.com/Jean-Baptiste-Lasselle/lauriane/master/recette-provisionning-lx-user-provision-scala.sh
chmod +x ./recette-provisionning-lx-user-provision-scala.sh
./recette-provisionning-lx-user-provision-scala.sh
```

* Créez un projet Maven eclipse à partir du [modèle de projet maven](https://github.com/Jean-Baptiste-Lasselle/mavenisation-siteweb-usinelogicielle) (futur archetype maven)
* utilisez le goal "provision-scala" du [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin):
`mvn clean deployeur:provision-scala`

## Variables d'environnement

Cette recette comporte deux varibles d'environnements dont la valeur est utilisées pour configurer le [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin)

Vous pouvez vous inspirer de cet [exemple de configuration du pom.xml](https://github.com/Jean-Baptiste-Lasselle/mavenisation-siteweb-usinelogicielle), permettant d'utiliser  le [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin) sur un pipeline Scala.


* `MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME`  : définit le user linux qui sera utilisé par le [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin) pour opérer les déploiements scala. Cette variable d'environnement est liée au paramètre de configuration "`<ops-lx-user>leuserlinuxquevousavezcréé</ops-lx-user>`" du [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin).

* `REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT`  : définit dans quel répertoire L'application scala est déployée par le [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin) ? C'est dans ce répertoire que la commande st sera lancée.". Par défaut, le répertoire utilisé sera le répertoire /home/$MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME/provisionning-scala/software-factory-website". Cette variable d'environnement est liée au paramètre de configuration "`<repertoire-deploiement-scala>/chemin/de/repertoire/de/votre/choix</repertoire-deploiement-scala>`" du [deployeur-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/deployeur-maven-plugin).

## TODOs

* Faire un archetype maven pour le type de projet maven-scala, avec dedans une configuration typique du pom.xml, en remplacement de l'[exemple de configuration du pom.xml](https://github.com/Jean-Baptiste-Lasselle/mavenisation-siteweb-usinelogicielle)
