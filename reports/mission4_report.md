# Rapport Mission 4 – Service systemd custom

**Auteur :** Celina AZZOUZI
**Date :** 2026-06-21 
**Distribution :** Ubuntu 24.04.3 LTS---

## 1\. Fichier unit logwatcher.service

```# ============================================================

\# Fichier  : logwatcher.service

\# Auteur   : Celina AZZOUZI

\# Date     : 2026-06-20

\# Desc     : Service systemd pour la surveillance SSH

\# Deploy   : sudo cp configs/logwatcher.service /etc/systemd/system/

\#            sudo systemctl daemon-reload

\#            sudo systemctl enable --now logwatcher

\# ============================================================



\[Unit]

Description=Service de surveillance des tentatives de connexion SSH suspectes

After=network.target syslog.target



\[Service]

Type=simple

User=root

ExecStart=/bin/bash /home/celina/linux-admin-b2-celina-azzouzi/scripts/logwatcher.sh

Restart=on-failure

RestartSec=10s

StandardOutput=journal

StandardError=journal

SyslogIdentifier=logwatcher



\[Install]

WantedBy=multi-user.target

```

\---

## 2\. Déploiement et activation

```bash
sudo cp configs/logwatcher.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now logwatcher
```

\---

## 3\. État du service

```bash
sudo systemctl status logwatcher
```

```
● logwatcher.service - Service de surveillance des tentatives de connexion SSH suspectes

&#x20;    Loaded: loaded (/etc/systemd/system/logwatcher.service; enabled; preset: enabled)

&#x20;    Active: active (running) since Mon 2026-06-22 19:13:52 UTC; 1min 18s ago

&#x20;  Main PID: 4885 (bash)

&#x20;     Tasks: 2 (limit: 6015)

&#x20;    Memory: 692.0K (peak: 1.7M)

&#x20;       CPU: 170ms

&#x20;    CGroup: /system.slice/logwatcher.service

&#x20;            ├─4885 /bin/bash /home/celina/linux-admin-b2-celina-azzouzi/scripts/logwatcher.sh

&#x20;            └─4910 sleep 30



Jun 22 19:13:52 linux systemd\[1]: Started logwatcher.service - Service de surveillance des tentatives de connexion SSH >

Jun 22 19:13:52 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:13:52
```

\---

## 4\. Logs journald (20 dernières lignes)

```bash
sudo journalctl -u logwatcher --no-pager -n 20
```

```

Jun 22 19:13:52 linux systemd\[1]: Started logwatcher.service - Service de surveillance des tentatives de connexion SSH suspectes.

Jun 22 19:13:52 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:13:52

Jun 22 19:14:22 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:14:22

Jun 22 19:14:53 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:14:52

Jun 22 19:15:23 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:15:23

Jun 22 19:15:53 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:15:53

Jun 22 19:16:23 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:16:23

Jun 22 19:16:53 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:16:53

Jun 22 19:17:24 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:17:23

Jun 22 19:17:54 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:17:54

Jun 22 19:18:24 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:18:24

Jun 22 19:18:54 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:18:54

Jun 22 19:19:24 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:19:24

Jun 22 19:19:54 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:19:54

Jun 22 19:20:24 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:20:24

Jun 22 19:20:54 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:20:54

Jun 22 19:21:24 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:21:24

Jun 22 19:21:55 linux logwatcher\[4885]: \[LOGWATCHER] 0 tentative(s) SSH échouée(s) — 19:21:55

celina@linux:\~/linux-admin-b2-celina-azzouzi$
```

\---

## 5\. Fichier de log activity.log

```bash
cat /var/log/logwatcher/activity.log
```

```
celina@linux:\~/linux-admin-b2-celina-azzouzi$ cat /var/log/logwatcher/activity.log

2026-06-22 19:13:52 | Nouvelles: 0 | Total: 10

2026-06-22 19:14:22 | Nouvelles: 0 | Total: 10

2026-06-22 19:14:53 | Nouvelles: 0 | Total: 10

2026-06-22 19:15:23 | Nouvelles: 0 | Total: 10

2026-06-22 19:15:53 | Nouvelles: 0 | Total: 10

2026-06-22 19:16:23 | Nouvelles: 0 | Total: 10

2026-06-22 19:16:53 | Nouvelles: 0 | Total: 10

2026-06-22 19:17:24 | Nouvelles: 0 | Total: 10

2026-06-22 19:17:54 | Nouvelles: 0 | Total: 10

2026-06-22 19:18:24 | Nouvelles: 0 | Total: 10

2026-06-22 19:18:54 | Nouvelles: 0 | Total: 10

2026-06-22 19:19:24 | Nouvelles: 0 | Total: 10

2026-06-22 19:19:54 | Nouvelles: 0 | Total: 10

2026-06-22 19:20:24 | Nouvelles: 0 | Total: 10

2026-06-22 19:20:54 | Nouvelles: 0 | Total: 10

2026-06-22 19:21:24 | Nouvelles: 0 | Total: 10

2026-06-22 19:21:55 | Nouvelles: 0 | Total: 10

2026-06-22 19:22:25 | Nouvelles: 0 | Total: 10

2026-06-22 19:22:56 | Nouvelles: 0 | Total: 10

2026-06-22 19:23:26 | Nouvelles: 0 | Total: 10

2026-06-22 19:23:56 | Nouvelles: 0 | Total: 10

2026-06-22 19:24:26 | Nouvelles: 0 | Total: 10

2026-06-22 19:24:57 | Nouvelles: 0 | Total: 10

2026-06-22 19:25:27 | Nouvelles: 0 | Total: 10

2026-06-22 19:25:57 | Nouvelles: 0 | Total: 10

2026-06-22 19:26:27 | Nouvelles: 0 | Total: 10

2026-06-22 19:26:57 | Nouvelles: 0 | Total: 10

2026-06-22 19:27:27 | Nouvelles: 0 | Total: 10

2026-06-22 19:27:57 | Nouvelles: 0 | Total: 10

2026-06-22 19:28:28 | Nouvelles: 0 | Total: 10

2026-06-22 19:28:58 | Nouvelles: 0 | Total: 10

2026-06-22 19:29:28 | Nouvelles: 0 | Total: 10

2026-06-22 19:29:58 | Nouvelles: 0 | Total: 10

2026-06-22 19:30:28 | Nouvelles: 0 | Total: 10

2026-06-22 19:30:58 | Nouvelles: 0 | Total: 10

2026-06-22 19:31:28 | Nouvelles: 0 | Total: 10


```

\---

## 6\. Explication : Type=simple vs Type=forking

<!-- Expliquer la différence entre ces deux types.
     Pourquoi simple est-il adapté à logwatcher.sh ?

Type=simple vs Type=forking

Type=simple : C'est le mode par défaut de systemd. Ici, systemd lance le script et considère qu'il fonctionne tant que ce script reste ouvert au premier plan. Comme notre script logwatcher.sh contient une boucle infinie (while true), il ne s'arrête jamais tout seul et reste bloqué au premier plan. Le mode Type=simple est donc exactement ce qu'il nous faut. 

Type=forking : On utilise ce mode pour les vrais services réseaux (comme Apache ). Ces programmes ont un comportement différent : ils se lancent, créent un processus enfant ("fork") pour travailler en tâche de fond, puis le script parent s'arrête immédiatement pour redonner la main au terminal. Systemd doit alors surveiller le processus enfant qui est resté en arrière-plan.  

---

## 7\\. Explication : Restart=on-failure

<!-- Expliquer ce que fait cette directive.

La directive Restart=on-failure sert de sécurité. Elle dit à systemd : "Si le script s'arrête avec une erreur ou se fait tuer par le système parce qu'il n'y a plus de mémoire, redémarre-le automatiquement au bout de 10 secondes".


