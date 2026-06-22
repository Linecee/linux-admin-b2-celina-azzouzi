# Rapport Mission 5 – Sécurisation SSH \& pare-feu

**Auteur :** Celina AZZOUZI  
**Date :** 2026-06-22 
**Distribution :** Ubuntu 24.04.3 LTS

\---

## 1\. Exécution du script de durcissement

```bash
sudo ./scripts/harden\_ssh.sh
```

**Sortie :**

```
== Sauvegarde de la configuration actuelle ==

Sauvegarde créée : /etc/ssh/sshd\_config.bak.20260622

== Application des paramètres ==

&#x20; MaxAuthTries -> 3

&#x20; PermitRootLogin -> no

&#x20; ClientAliveCountMax -> 2

&#x20; X11Forwarding -> no

&#x20; PubkeyAuthentication -> yes

&#x20; LoginGraceTime -> 20

&#x20; ClientAliveInterval -> 300

&#x20; PasswordAuthentication -> no

== Validation de la syntaxe (sshd -t) ==

Configuration valide.



===== DIFF (ancienne vs nouvelle config) =====

================================================



⚠️  La configuration a été mise à jour mais sshd N'A PAS été redémarré.

&#x20;   Gardez votre session SSH actuelle ouverte, vérifiez la config,

&#x20;   puis dans une AUTRE session lancez :

&#x20;     sudo systemctl restart sshd

&#x20;   et testez une nouvelle connexion avant de fermer la première.```

\---

## 2\. Diff – avant / après

```bash
diff /etc/ssh/sshd\_config.bak.YYYYMMDD /etc/ssh/sshd\_config
```

< #LoginGraceTime 2m

< #PermitRootLogin prohibit-password

\---

> LoginGraceTime 20

> PermitRootLogin no

44c44

< #MaxAuthTries 6

\---

> MaxAuthTries 3

47c47

< #PubkeyAuthentication yes

\---

> PubkeyAuthentication yes

66c66

< #PasswordAuthentication yes

\---

> PasswordAuthentication no

99c99

< X11Forwarding yes

\---

> X11Forwarding no

108,109c108,109

< #ClientAliveInterval 0

< #ClientAliveCountMax 3

\---

> ClientAliveInterval 300

> ClientAliveCountMax 2

128c128

< #     X11Forwarding no

\---

> X11Forwarding no



\---

## 3\. Validation de la syntaxe

```bash
sudo sshd -t
echo "Code retour : $?"
```
Code retour : 0

\---

## 4\. Configuration UFW

Commandes exécutées :

```bash
sudo ufw default deny incoming

sudo ufw default allow outgoing

sudo ufw allow 22/tcp

sudo ufw allow 80/tcp

sudo ufw allow 443/tcp

sudo ufw deny from 192.0.2.0/24

sudo ufw enable
```

**État du pare-feu :**

```bash
sudo ufw status verbose
```

Status: active

Logging: on (low)

Default: deny (incoming), allow (outgoing), disabled (routed)

New profiles: skip



To                         Action      From

\--                         ------      ----

22/tcp                     ALLOW IN    Anywhere

80/tcp                     ALLOW IN    Anywhere

443/tcp                    ALLOW IN    Anywhere

Anywhere                   DENY IN     192.0.2.0/24

22/tcp (v6)                ALLOW IN    Anywhere (v6)

80/tcp (v6)                ALLOW IN    Anywhere (v6)

443/tcp (v6)               ALLOW IN    Anywhere (v6)

\---

## 5\. Test de connexion SSH

```bash
ssh -i \~/.ssh/id\_ed25519 -p 2222 celina@127.0.0.1
```

```
Welcome to Ubuntu 24.04.3 LTS (GNU/Linux 6.17.0-14-generic x86\_64)



&#x20;\* Documentation:  \[https://help.ubuntu.com](https://help.ubuntu.com)

&#x20;\* Management:     \[https://landscape.canonical.com](https://landscape.canonical.com)

&#x20;\* Support:        \[https://ubuntu.com/pro](https://ubuntu.com/pro)



Expanded Security Maintenance for Applications is not enabled.

Last login: Mon Jun 22 20:42:14 2026 from 10.0.2.2
```

La connexion s'établit instantanément et de manière sécurisée sans aucune demande de mot de passe. Le serveur SSH a validé la clé publique ED25519 générée sur la machine hôte Windows. Cela prouve le bon fonctionnement de l'authentification par clé asymétrique.

\---

## 6\. Analyse : pourquoi PasswordAuthentication no est-il critique ?

<!-- 5 lignes minimum expliquant :
     - ce qu'est une attaque par brute-force SSH
     - pourquoi les mots de passe sont vulnérables même complexes
     - ce qu'apportent les clés SSH en comparaison

Désactiver les mots de passe avec PasswordAuthentication no est indispensable pour protéger un serveur. Sur Internet, il y a des milliers de robots qui testent des listes géantes de mots de passe sur tous les serveurs qu'ils trouvent, en espérant tomber sur le bon (attaque par force brute). Même si on choisit un mot de passe très long et complexe, il reste vulnérable car il peut être deviné par un ordinateur ultra-puissant, volé lors d'une fuite de données, ou tapé sur un faux site.



En bloquant les mots de passe, on oblige le serveur à n'accepter que des clés SSH. Une clé SSH, c'est comme une carte d'identité numérique ultra-sécurisée sous forme de fichier. Sa structure mathématique est tellement complexe qu'un robot mettrait des millions d'années à essayer de la deviner. C'est beaucoup plus sûr que de simplement bloquer le compte root (PermitRootLogin no), car si on laisse les mots de passe activés, les pirates peuvent toujours essayer de forcer l'accès aux autres comptes du serveur (comme mon compte celina).

\---

## 7\. Réflexion : mesures de durcissement complémentaires en production

<!-- Citer et expliquer brièvement 3 mesures supplémentaires que vous ajouteriez

Pour sécuriser encore plus un serveur dans une vraie entreprise, je rajouterais ces trois options :



Changer le numéro du port SSH : Au lieu de laisser le SSH sur son port par défaut (le port 22), on le met sur un numéro au hasard (par exemple le 4549). Cela permet de cacher le serveur et d'éviter 99 % des attaques des robots qui ne cherchent que le port 22.



Installer Fail2Ban : C'est un petit outil qui surveille les erreurs de connexion. Si une adresse IP se trompe plusieurs fois d'affilée en essayant de se connecter, Fail2Ban la bloque automatiquement au niveau du pare-feu pendant quelques heures ou quelques jours.



Mettre une bannière d'avertissement : Configurer un texte juridique strict qui s'affiche dès qu'on tente de se connecter (ex: "Accès privé et surveillé. Tout intrus sera poursuivi"). Cela permet d'avoir une vraie valeur légale et de pouvoir porter plainte en cas de tentative de piratage.

