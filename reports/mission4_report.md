# Rapport Mission 4 — Service systemd custom

## 1. Fichier unit complet

```ini
[Unit]
Description=Surveillance des tentatives de connexion SSH échouées
After=network.target syslog.target

[Service]
Type=simple
ExecStart=/usr/local/bin/logwatcher.sh
Restart=on-failure
RestartSec=10s
StandardOutput=journal
StandardError=journal
SyslogIdentifier=logwatcher

[Install]
WantedBy=multi-user.target
```

## 2. Statut du service

```
$ sudo systemctl status logwatcher
(coller la sortie)
```

## 3. Journal du service

```
$ sudo journalctl -u logwatcher --no-pager -n 20
(coller la sortie)
```

## 4. Fichier de log applicatif

```
$ cat /var/log/logwatcher/activity.log
(coller la sortie)
```

## 5. Type=simple vs Type=forking

(à rédiger : `Type=simple` indique à systemd que le processus lancé par
`ExecStart` est lui-même le processus principal du service, qui reste au
premier plan ; systemd considère le service comme démarré dès l'exécution de
la commande. `Type=forking` est utilisé pour les démons traditionnels qui se
"forkent" eux-mêmes en arrière-plan puis terminent leur processus parent ;
systemd doit alors suivre le PID du processus enfant, généralement via un
fichier PID, pour savoir lequel surveiller.)

## 6. Que fait Restart=on-failure ?

(à rédiger : systemd relance automatiquement le service uniquement si celui-ci
se termine avec un code de sortie différent de 0, ou s'il est tué par un
signal anormal — pas s'il est arrêté volontairement via `systemctl stop`.
Combiné à `RestartSec=10s`, systemd attend 10 secondes avant chaque tentative
de relance, ce qui évite une boucle de redémarrage trop agressive.)
