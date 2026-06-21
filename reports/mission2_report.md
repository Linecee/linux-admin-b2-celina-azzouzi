# Rapport Mission 2 – Gestion des utilisateurs & groupes

**Auteur :** Celina AZZOUZI
**Date :** 2026-06-21
**Distribution :** Ubuntu 24.04 LTS

---

## 1. Exécution du script

```bash
sudo ./scripts/create_users.sh
```

**Sortie :**

```
== Création des groupes ==
Groupe devteam créé (GID 3001).
Groupe ops créé (GID 3002).
== Création des utilisateurs ==
Utilisateur alice créé (UID 2001, groupe primaire devteam).
Utilisateur bob créé (UID 2002, groupe primaire devteam).
Utilisateur charlie créé (UID 2003, groupe primaire ops).
== Ajout d'alice au groupe ops ==
alice ajoutée au groupe ops.
== Création de /opt/devproject ==
/opt/devproject créé.

===== RÉCAPITULATIF =====
--- alice ---
uid=2001(alice) gid=3001(devteam) groups=3001(devteam),3002(ops)
--- bob ---
uid=2002(bob) gid=3001(devteam) groups=3001(devteam)
--- charlie ---
uid=2003(charlie) gid=3002(ops) groups=3002(ops)
--- /opt/devproject ---
drwxrwx--- 2 root devteam 4096 Jun 21 09:38 /opt/devproject
==========================
```

---

## 2. Vérification des comptes créés

```bash
id alice
```

```
uid=2001(alice) gid=3001(devteam) groups=3001(devteam),3002(ops)
```

```bash
id bob
```

```
uid=2002(bob) gid=3001(devteam) groups=3001(devteam)
```

```bash
id charlie
```

```
uid=2003(charlie) gid=3002(ops) groups=3002(ops)
```

---

## 3. Vérification des groupes

```bash
cat /etc/group | grep -E 'devteam|ops'
```

```
whoopsie:x:109:
devteam:x:3001:
ops:x:3002:alice
```

---

## 4. Vérification du répertoire projet

```bash
ls -ld /opt/devproject/
```

```
drwxrwx--- 2 root devteam 4096 Jun 21 09:38 /opt/devproject/
```

---

## 5. Analyse : comportement en cas de double exécution

Si le script est lancé une deuxième fois, il reste parfaitement stable et se comporte de manière idempotente. J'ai géré ce cas à l'aide de vérifications préalables avant chaque action :

- **Pour les groupes** : la commande `getent group <nom>` vérifie si le groupe existe déjà dans le système. S'il est présent, le script l'indique dans le terminal et passe à la suite, au lieu de laisser `groupadd` renvoyer une erreur fatale.
- **Pour les utilisateurs** : la commande `id <nom>` interroge le système. Si l'utilisateur est détecté, `useradd` n'est pas appelé pour cet utilisateur, ce qui évite d'interrompre l'exécution du script.

Grâce à ces vérifications, le script peut être exécuté autant de fois que nécessaire sans jamais dupliquer de comptes ni altérer les droits déjà en place.
