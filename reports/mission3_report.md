# Rapport Mission 3 — Système de fichiers & permissions

## 1. Arborescence complète

```
$ ls -laR /srv/devproject/
(coller la sortie)
```

## 2. ACL sur docs/

```
$ getfacl /srv/devproject/docs/
(coller la sortie)
```

## 3. Test en tant qu'alice (création dans src/)

```
$ su - alice
$ touch /srv/devproject/src/fichier_alice.txt
$ ls -la /srv/devproject/src/
(coller la sortie — vérifier le groupe propriétaire grâce au SGID)
```

## 4. Test en tant que charlie (lecture dans docs/)

```
$ su - charlie
$ cat /srv/devproject/docs/test_docs.txt
(coller la sortie — doit fonctionner grâce à l'ACL r-x)
$ touch /srv/devproject/docs/fichier_charlie.txt
(coller la sortie — doit échouer, charlie n'a pas le droit d'écrire)
```

## 5. Le SGID dans un contexte collaboratif

(à rédiger en 5-10 lignes : expliquer que le SGID sur un dossier force tout
nouveau fichier/sous-dossier créé à hériter du groupe du dossier parent
(`devteam`) plutôt que du groupe primaire de l'utilisateur créateur. Dans un
contexte collaboratif comme `/srv/devproject/src`, cela garantit que tous les
membres de `devteam` peuvent accéder aux fichiers créés par n'importe quel
membre de l'équipe, sans devoir faire un `chgrp` manuel après chaque création.
Sans SGID, un fichier créé par `bob` (groupe primaire `devteam`) appartiendrait
bien à `devteam`, mais si un autre utilisateur avait un groupe primaire
différent, ses fichiers échapperaient au partage — le SGID uniformise ce
comportement pour tout le monde.)
