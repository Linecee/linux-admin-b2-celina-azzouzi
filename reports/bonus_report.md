# Rapport Bonus – Durcissement SSH étendu

**Auteur :** Celina AZZOUZI
**Date :** 2026-06-22
**Distribution :** Ubuntu 24.04.3 LTS
**Option choisie :** Option C – Durcissement SSH avancé

\---

## 1\. AllowUsers – Restriction des utilisateurs autorisés

**Commande exécutée :**

```bash
echo "AllowUsers celina" | sudo tee -a /etc/ssh/sshd\_config
```

**Sortie :**

```
AllowUsers celina
```

**Explication :**

La directive `AllowUsers` restreint les connexions SSH aux seuls utilisateurs explicitement listés. Même si d'autres comptes existent sur le serveur (alice, bob, charlie,...), ils ne pourront pas se connecter via SSH. C'est une mesure de défense en profondeur : en cas de compromission d'un compte non listé, l'attaquant ne peut pas l'utiliser pour accéder au serveur à distance.

\---

## 2\. Banner de connexion

**Commandes exécutées :**

```bash
sudo bash -c 'echo "Accès privé et surveillé. Toute connexion non autorisée est interdite et sera signalée." > /etc/issue.net'
echo "Banner /etc/issue.net" | sudo tee -a /etc/ssh/sshd\_config
sudo sshd -t
```

**Sortie de sshd -t :**

```
(aucune sortie = configuration valide)
```

**Contenu de /etc/issue.net :**

```
Accès privé et surveillé. Toute connexion non autorisée est interdite et sera signalée.
```

**Explication :**

La bannière de connexion s'affiche à chaque tentative de connexion SSH, avant l'authentification. Elle a une double utilité : dissuader les attaquants potentiels et constituer une base juridique en cas de plainte pour intrusion (elle prouve que l'accès non autorisé était explicitement interdit et connu).

\---

## 3\. Configuration Fail2Ban pour SSH

**Fichier /etc/fail2ban/jail.local créé :**

```ini
\[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600
```

**Commandes exécutées :**

```bash
sudo systemctl enable --now fail2ban
sudo systemctl status fail2ban
sudo fail2ban-client status sshd
```

**Sortie de systemctl status fail2ban :**

```
● fail2ban.service - Fail2Ban Service
     Loaded: loaded (/usr/lib/systemd/system/fail2ban.service; enabled; preset: enabled)
     Active: active (running) since Mon 2026-06-22 21:44:13 UTC; 30min ago
       Docs: man:fail2ban(1)
   Main PID: 9486 (fail2ban-server)
      Tasks: 5 (limit: 6015)
     Memory: 20.2M (peak: 20.7M)
        CPU: 3.193s
     CGroup: /system.slice/fail2ban.service
             └─9486 /usr/bin/python3 /usr/bin/fail2ban-server -xf start
Jun 22 21:44:13 linux systemd\[1]: Started fail2ban.service - Fail2Ban Service.
Jun 22 21:44:13 linux fail2ban-server\[9486]: Server ready
```

**Sortie de fail2ban-client status sshd :**

```
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     0
|  `- Journal matches:  \_SYSTEMD\_UNIT=sshd.service + \_COMM=sshd
`- Actions
   |- Currently banned: 0
   |- Total banned:     0
   `- Banned IP list:
```

**Explication de la configuration :**

* `maxretry = 3` : une IP est bannie après 3 échecs d'authentification
* `bantime = 3600` : le bannissement dure 1 heure (3600 secondes)
* `findtime = 600` : les 3 échecs doivent se produire dans une fenêtre de 10 minutes

Fail2Ban surveille `/var/log/auth.log` en temps réel. Dès qu'une IP dépasse le seuil de tentatives échouées, elle est automatiquement bloquée via une règle UFW/iptables. Cela rend les attaques par force brute quasi impossibles sans déclencher un bannissement rapide.

\---

## 4\. Validation finale

```bash
sudo sshd -t
echo "Code retour : $?"
```

```
Code retour : 0
```

La configuration SSH complète (AllowUsers + Banner + Fail2Ban) est valide et opérationnelle.

