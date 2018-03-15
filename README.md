# Information

Ce repo est en cours de construction, pour constituer un support de formation en ligne.

# Résumé

Ce repo est documenté par ./ModdeDemploi.pdf, qui permet de monter des pipelines un peu particuliers...


# Pour développer une application Scala

 [B.O.M.](https://www.youtube.com/watch?v=dHJUPm8X8I0)

 <!-- ![Un peu de rythme pour les opérations](# "Rock with U") -->
 <!-- ![Un peu de rythme pour les opérations](https://github.com/Jean-Baptiste-Lasselle/lauriane/blob/master/documentation/image/rock-with-u.jpg?raw=true "Rock with U") -->
 
## A. Mettez votre cible de déploiement dans son état de livraison

À l'issue de ces opérations, votre cible de déploiement:
* sera prête à se voir appliquer la [recette de provision scala](#b-mettez-votre-cible-de-déploiement-dans-son-état-initial)
* l'adresse IP de toutes les machines de la cible de déploiement sont accessibles depuis la machine sur laquelle vous développez.

Votre cible de déploiement Scala se réduira à sa plus simple expression, que nous allons tous de même construire et opérer aussi sérieusement (avec réalisme) que possible: 
Une seule et unique machine, qu'elle soit physique ou virtuelle.

Procédez comme suit pour :

* Créez une VM VirtualBox
* Installez une version d'Ubuntu de la famille 16.x LTS, dans cette VM
* Au cours de la procédure d'installation d'Ubuntu, créez un utilisateur linux adminsitrateur : il aura la possibilité d'exécuter des commandes avec `sudo`. Je noterai `$OPERATEUR_LINUX_LIVRAISON` le username linux de cet utilisateur, dans toute cette documentation.
* Avec cet utilisateur linux administrateur, Exécutez ensuite:
```
# Un update de votre système:
sudo apt-get update -y
# Une installation d'un serveur SSH:
sudo apt-get install -y openssh-server
# L'installation de git:
sudo apt-get install -y git
```

Imaginions, que, comme moi pour réaliser mes tests, vous utilisiez une machine virtuelle, vous pourriez, à
l'issue des opérations ci-dessus, réaliser un `snapshot` de la machine virtuelle:
Ainsi, si dans la suite des opérations vous rencontrez un problème quelconque, vous
n'aurez pas besoin de réaliser ces opérations une nouvelle fois.

## B. Mettez votre cible de déploiement dans son état initial

À l'issue de ces opérations, votre cible de déploiement:
* sera prête à recevoir le déploiement d'une application Scala. 
* offrira à toute application Scala déployée en son sein, la possibilité de faire usage d'une base de données PostGreSQL.

Imaginions, que, comme moi pour réaliser mes tests, vous utilisiez une machine virtuelle, vous pourriez, à
l'issue des opérations décrites ci-dessous, réaliser un `snapshot` de la machine virtuelle:
Ainsi, si dans la suite des opérations vous rencontrez un problème quelconque, vous
n'aurez pas besoin de réaliser ces opérations une nouvelle fois.

### Première possibilité: Clonez le repo de référence de la recette, et exécutez-là

Pour mettre votre cible de déploiement dans son état initial, vous allez réaliser
des opérations dans votre cible de déploiement à l'aide d'un utilisateur linux.
PAr exemple, pour installer PostGreSQL.

Etant donné les opérations à réaliser, cet utilisateur linux devra
être administrateur: il doit pouvoir exécuter des commandes shell avec sudo.

Vous pouvez créer un tel utilisateur avec les commandes suivantes:
```
export NOM_DU_FUTUR_UTILISATEUR_LINUX=scala-provisioner
# cette commande vous demandera une saisie interactive, exécutez-là séparément de la commande suivante.
adduser $NOM_UTILISATEUR_LINUX_PROVISION_SCALA
# puis lorsque vous avez terminé les saisies interactives exigées
# par la commande précédente, exécutez:
usermod -aG sudo $NOM_UTILISATEUR_LINUX_PROVISION_SCALA
```

Avec l'utilisateur linux `$NOM_UTILISATEUR_LINUX_PROVISION_SCALA`, exécutez une à une, les
instructions suivantes:

```
# utilisez l'utilisateur linux créé précédemment
su $NOM_DU_FUTUR_UTILISATEUR_LINUX
# l'URI du repo git du code source de l'application scala qui sera déployée initialement
export URI_REPO_GIT_CODE_SOURCE_APP_SCALA=http://nomdedomaineouip:noport/chemin/vers/repo/code/soure/de/votre/application/scala
# l'URI du repo git de la recette de provision de l'état initial de la cible de déploiement
export URI_REPO_GIT_RECETTE_PROVISION_ETAT_INITIAL=https://github.com/Jean-Baptiste-Lasselle/lauriane

export PROVISIONNING_HOME=$HOME/provisionning-scala
rm -rf $PROVISIONNING_HOME
mkdir -p $PROVISIONNING_HOME/recettes-operations
git clone $URI_REPO_GIT_RECETTE_PROVISION_ETAT_INITIAL $PROVISIONNING_HOME/recettes-operations
sudo chmod +x $PROVISIONNING_HOME/recettes-operations/monter-cible-deploiement-scala.sh
cd $PROVISIONNING_HOME/recettes-operations
./monter-cible-deploiement-scala.sh $URI_REPO_GIT_CODE_SOURCE_APP_SCALA
```

### Deuxième possibilité: Utilisez le [fullstack-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/fullstack-maven-plugin)

Le goal "provision-scala" du [fullstack-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/fullstack-maven-plugin) vous permet de réaliser
la provision de l'état initial de la cible de déploiement, en automatisant les opérations décrites dans
le [paragraphe précédent](#premi%C3%A8re-possibilit%C3%A9-clonez-le-repo-de-r%C3%A9f%C3%A9rence-de-la-recette-et-ex%C3%A9cutez-l%C3%A0)

Afin d'utiliser le [fullstack-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/fullstack-maven-plugin) vous devrez donc:

* Mettre votre cible de déploiement dans son état de livraison, comme décrit dans le
paragraphe ["Mettez votre cible de déploiement dans son état de livraison"](#mettez-votre-cible-de-déploiement-dans-son-état-de-livraison-avant-la-provision-scala)
* Avec l'utilisateur linux administrateur créé dans le paragraphe ["Mettez votre cible de déploiement dans son état de livraison"](#mettez-votre-cible-de-déploiement-dans-son-état-de-livraison-avant-la-provision-scala)(`$OPERATEUR_LINUX_LIVRAISON`), exécutez:
```
curl -O https://raw.githubusercontent.com/Jean-Baptiste-Lasselle/lauriane/master/recette-provisionning-lx-user-provision-scala.sh
chmod +x ./recette-provisionning-lx-user-provision-scala.sh
./recette-provisionning-lx-user-provision-scala.sh
```

* Créez un projet Maven eclipse à partir du [modèle de projet maven](https://github.com/Jean-Baptiste-Lasselle/mavenisation-siteweb-usinelogicielle) (futur archetype maven)
* Exécutez le goal "provision-scala" du [fullstack-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/fullstack-maven-plugin) (ce qui mettra votre cible de déploiement dans son état initial):
`mvn clean fullstack:provision-scala`
* Exécutez le goal "deploy-scala-app" (ce qui automatisera le cycle de développement) :
`mvn clean fullstack:deploy-scala-app`
* Votre application Scala est déployée: Effectuez les tests qui ne sont pas automatisés dans le build de votre application Scala ([build.sbt](https://www.scala-sbt.org/))
* Editez:
  * le code source de votre applicaton scala, et/ou
  * le code source des tests de votre application Scala, et/ou
  * le code source de la recette de montée de la cible de déploiement,
* Exécutez le goal "deploy-scala-app" (ce qui automatisera le cycle de développement) :
`mvn clean fullstack:deploy-scala-app`

## C. Commencez à développer

[B.O.M.](https://www.youtube.com/watch?v=l7ZlSHGFfdc)

Le [fullstack-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/fullstack-maven-plugin) vous permet de développer une 
application scala, en automatisant le cycle de développement avec son goal maven `deploy-scala-app`).
Vous modifiez le code source de votre application, et le plugin réalise:
* le commit & push du code source modifié vers:
    * le repo git qui constitue votre référentiel de versionning du code source de votre applicaton scala (si vous avez modifié le code source de l'application)
    * le repo git qui constitue votre référentiel de versionning du code source des tests de votre applicaton scala  (si vous avez modifié le code source des tests de l'application)
    * le repo git qui constitue votre référentiel de versionning du code source de la recette de provision de la cible de déploiement de votre applicaton scala  (si vous avez modifié le code source de cette recette)
* le build de l'application scala
* le déploiement de l'application scala vers une cible de déploiement. La cible de déploiement doit être dans un état reproductible, appelé état initial.
* Vous réalisez les tests que vous n'avez pas automatisés dans le build de l'application
* Vous remettez votre cible de déploiement dans son état initial, 
* et vous recommencez...

Ce paragraphe décrit comment utiliser le  [fullstack-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/fullstack-maven-plugin)
pour gérer votre cycle de développement d'une application scala.

Afin d'utiliser le [fullstack-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/fullstack-maven-plugin) vous devrez donc:

* Mettre votre cible de déploiement dans son état de livraison, comme décrit dans le
paragraphe ["Mettez votre cible de déploiement dans son état de livraison"](#mettez-votre-cible-de-déploiement-dans-son-état-de-livraison-avant-la-provision-scala).
* Mettre votre cible de déploiement dans son état initial, avec la [méthode manuelle](#première-possibilité-clonez-le-repo-de-référence-de-la-recette-et-exécutez-là), ou 
[en utilisant le fullstack-maven-plugin](#deuxième-possibilité-utilisez-le-fullstack-maven-plugin)). 
Votre cible de déploiement est maitnenant prête à recevoir le déploiement de votre application Scala.
* Sur une machine dans le même réseau IP que votre cible de déploiement, Créez un projet Maven eclipse à partir du [modèle de projet maven](https://github.com/Jean-Baptiste-Lasselle/mavenisation-siteweb-usinelogicielle) (futur archetype maven)
* Editez le pom.xml, pour indiquer:
  * l'URI du repository Git du code source de votre application Scala:
  
    `<url-repo-git-app-scala>https://github.com/Jean-Baptiste-Lasselle/siteweb-usinelogicielle.com</url-repo-git-app-scala>`
	
  * Le nom d'un utilisateur ayant les droits nécessaires pour pousser sur le repository Git du code source de votre application Scala.
    
    `<ops-git-username>Jean-Baptiste-Lasselle</ops-git-username>`
    
  * l'URI d'un autre repository Git, qui doit simplement exister (créez-en un).
    Le [fullstack-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/fullstack-maven-plugin) l'utilisera 
	pour réaliser les déploiements de votre application Scala (L'usage de ce repo doit donc lui être réservé):
  
    `<url-repo-git-deploiements>https://github.com/Jean-Baptiste-Lasselle/deploiement-usine-logicielle.com</url-repo-git-deploiements>`
  
  * l'adresse IP (ou le nom de domaine, le hostname) de votre cible de déploiement:
  
    `<ip-cible-srv-scala>192.168.1.22</ip-cible-srv-scala>`
  
  * le nom de l'utilisateur linux, et son mot de passe, que le [fullstack-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/fullstack-maven-plugin) utilisera pour opérer dans la cible de déploiement:
  
    ```
	<ops-lx-user>genehackman</ops-lx-user>
    <ops-lx-pwd>geneh@ckmanssecretfeaturingintheinvaders</ops-lx-pwd>
	```
	
* Exécutez le goal "deploy-scala-app" :
`mvn clean fullstack:deploy-scala-app`
* Votre application Scala est déployée: Effectuez les tests qui ne sont pas automatisés dans le build de votre application Scala ([build.sbt](https://www.scala-sbt.org/))
* Modifiez:
  * le code source de votre applicaton scala, et/ou
  * le code source des tests de votre application Scala, et/ou
  * le code source de la recette de montée de la cible de déploiement,
* Exécutez le goal "deploy-scala-app" :
`mvn clean fullstack:deploy-scala-app`


## ANNEXE: Variables d'environnement

Cette recette comporte deux varibles d'environnements dont les valeurs sont utilisées pour configurer le [fullstack-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/fullstack-maven-plugin)

Vous pouvez vous inspirer de cet [exemple de configuration du pom.xml](https://github.com/Jean-Baptiste-Lasselle/mavenisation-siteweb-usinelogicielle), permettant d'utiliser  le [fullstack-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/fullstack-maven-plugin) sur un pipeline Scala.


* `MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME`  : définit le user linux qui sera utilisé par le [fullstack-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/fullstack-maven-plugin) pour opérer les déploiements scala. Cette variable d'environnement est liée au paramètre de configuration "`<ops-lx-user>leuserlinuxquevousavezcréé</ops-lx-user>`" du [fullstack-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/fullstack-maven-plugin).

* `REPERTOIRE_APP_SCALA_DS_CIBLE_DEPLOIEMENT`  : définit dans quel répertoire L'application scala est déployée par le [fullstack-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/fullstack-maven-plugin) ? C'est dans ce répertoire que la commande st sera lancée.". Par défaut, le répertoire utilisé sera le répertoire /home/$MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME/provisionning-scala/software-factory-website". Cette variable d'environnement est liée au paramètre de configuration "`<repertoire-deploiement-scala>/chemin/de/repertoire/de/votre/choix</repertoire-deploiement-scala>`" du [fullstack-maven-plugin](https://github.com/Jean-Baptiste-Lasselle/fullstack-maven-plugin).

## ANNEXE: TODOs

* Faire un archetype maven pour le type de projet maven-scala, avec dedans une configuration typique du pom.xml, en remplacement de l'[exemple de configuration du pom.xml](https://github.com/Jean-Baptiste-Lasselle/mavenisation-siteweb-usinelogicielle)
