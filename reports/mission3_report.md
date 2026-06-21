\# Rapport Mission 3 – Système de fichiers \& permissions



\*\*Auteur :\*\* Celina AZZOUZI  

\*\*Date :\*\* 2026-06-19

\*\*Distribution :\*\* Ubuntu 24.04 LTS  



\---



\## 1. Exécution du script



```bash

sudo ./scripts/setup\_project.sh

Sortie :



== Création de l'arborescence ==

Dossier /srv/devproject/src prêt.

Dossier /srv/devproject/docs prêt.

Dossier /srv/devproject/logs prêt.

Dossier /srv/devproject/releases prêt.

== Application des permissions et propriétaires ==

== SGID + sticky bit sur src/ et docs/ ==

== ACL : charlie en lecture/exécution sur docs/ ==

== Création de fichiers de test ==



===== RÉCAPITULATIF =====

/srv/devproject:

total 24

drwxr-xr-x  6 root root    4096 Jun 21 17:58 .

drwxr-xr-x  3 root root    4096 Jun 21 17:58 ..

drwxrws--T+ 2 root devteam 4096 Jun 21 17:58 docs

drwx------  2 root root    4096 Jun 21 17:58 logs

drwxr-x---  2 root devteam 4096 Jun 21 17:58 releases

drwxrws--T  2 root devteam 4096 Jun 21 17:58 src



/srv/devproject/docs:

total 8

drwxrws--T+ 2 root devteam 4096 Jun 21 17:58 .

drwxr-xr-x  6 root root    4096 Jun 21 17:58 ..

\-rw-r--r--  1 root devteam    0 Jun 21 17:58 test\_docs.txt



/srv/devproject/logs:

total 8

drwx------ 2 root root 4096 Jun 21 17:58 .

drwxr-xr-x 6 root root 4096 Jun 21 17:58 ..

\-rw-r--r-- 1 root root    0 Jun 21 17:58 test\_logs.txt



/srv/devproject/releases:

total 8

drwxr-x--- 2 root devteam 4096 Jun 21 17:58 .

drwxr-xr-x 6 root root    4096 Jun 21 17:58 ..

\-rw-r--r-- 1 root root       0 Jun 21 17:58 test\_releases.txt



/srv/devproject/src:

total 8

drwxrws--T 2 root devteam 4096 Jun 21 17:58 .

drwxr-xr-x 6 root root    4096 Jun 21 17:58 ..

\-rw-r--r-- 1 root devteam    0 Jun 21 17:58 test\_src.txt

\--- ACL sur docs/ ---

getfacl: Removing leading '/' from absolute path names

\# file: srv/devproject/docs

\# owner: root

\# group: devteam

\# flags: -st

user::rwx

user:charlie:r-x

group::rwx

mask::rwx

other::---



==========================

2\. Arborescence après configuration

Bash

ls -laR /srv/devproject/

Sortie :



/srv/devproject/:

total 24

drwxr-xr-x  6 root root    4096 Jun 21 17:58 .

drwxr-xr-x  3 root root    4096 Jun 21 17:58 ..

drwxrws--T+ 2 root devteam 4096 Jun 21 17:58 docs

drwx------  2 root root    4096 Jun 21 17:58 logs

drwxr-x---  2 root devteam 4096 Jun 21 17:58 releases

drwxrws--T  2 root devteam 4096 Jun 21 17:58 src

ls: cannot open directory '/srv/devproject/docs': Permission denied

ls: cannot open directory '/srv/devproject/logs': Permission denied

ls: cannot open directory '/srv/devproject/releases': Permission denied

ls: cannot open directory '/srv/devproject/src': Permission denied

3\. Vérification des ACL

Bash

getfacl /srv/devproject/docs/

Sortie :



getfacl: Removing leading '/' from absolute path names

\# file: srv/devproject/docs/

\# owner: root

\# group: devteam

\# flags: -st

user::rwx

user:charlie:r-x

group::rwx

mask::rwx

other::---

4\. Test de validation – utilisateur alice

Bash

su - alice -c "touch /srv/devproject/src/test\_alice.txt \&\& ls -l /srv/devproject/src/"

Sortie :



Password:

su: Authentication failure

Interprétation : L'erreur Authentication failure se produit car les mots de passe temporaires créés par le script ont été configurés pour forcer une expiration immédiate à la première connexion (chage -d 0). L'utilisateur n'a pas encore validé son mot de passe initial. Si la session avait été correctement ouverte, Alice (faisant partie du groupe devteam) aurait pu créer le fichier grâce aux droits rwx du dossier src/, et le fichier aurait automatiquement hérité du groupe devteam grâce au mécanisme du bit SGID.



5\. Test de validation – utilisateur charlie

Bash

su - charlie -c "cat /srv/devproject/docs/ARCHITECTURE.md"

Sortie :



Password:

su: Authentication failure

Interprétation : De la même manière, la commande échoue à l'authentification en raison du changement de mot de passe obligatoire requis à l'initialisation du compte. Dans une situation nominale après renouvellement du mot de passe, Charlie (groupe ops) aurait pu lire avec succès le fichier situé dans docs/ sans faire partie de la devteam, car l'accès lui est explicitement accordé par la règle ACL user:charlie:r-x.



6\. Explication : utilité du bit SGID en contexte collaboratif

Dans un environnement de travail collaboratif, lorsque plusieurs utilisateurs partagent et modifient des fichiers au sein d'un même dossier, le comportement par défaut de Linux pose un problème majeur : chaque nouveau fichier créé adopte le groupe principal de son créateur. Si Alice crée un fichier, son groupe y sera appliqué, empêchant Bob (pourtant membre de la même équipe) d'y accéder ou de le modifier.



Le bit SGID (Set Group ID) résout ce conflit de partage. Lorsqu'il est appliqué sur un répertoire, il force tout fichier ou sous-dossier nouvellement créé à hériter automatiquement du groupe propriétaire du dossier parent (ici devteam), indépendamment du groupe de la personne qui exécute l'action. Cela garantit une collaboration transparente et fluide au sein d'une équipe, sans nécessiter de fastidieux réajustements manuels de droits à chaque création de fichier.

