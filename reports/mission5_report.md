# Rapport Mission 5 — Sécurisation SSH & pare-feu

⚠️ Rappel : garder deux sessions SSH ouvertes en parallèle pendant cette mission.

## 1. Diff sshd_config.bak vs sshd_config

```
$ diff /etc/ssh/sshd_config.bak.AAAAMMJJ /etc/ssh/sshd_config
(coller la sortie)
```

## 2. Validation syntaxe

```
$ sudo sshd -t
(coller la sortie — vide si OK)
```

## 3. Configuration UFW (commandes + statut)

```
$ sudo ufw default deny incoming
$ sudo ufw default allow outgoing
$ sudo ufw allow 22/tcp
$ sudo ufw allow 80/tcp
$ sudo ufw allow 443/tcp
$ sudo ufw deny from 192.0.2.0/24
$ sudo ufw enable
$ sudo ufw status verbose
(coller la sortie de status verbose)
```

## 4. Test de connexion SSH

```
$ ssh utilisateur@IP_SERVEUR
(coller la sortie / confirmer que la connexion par clé fonctionne et que
 le mot de passe seul est refusé)
```

## 5. Pourquoi PasswordAuthentication no est-il critique ?

(à rédiger en 5 lignes min : désactiver l'authentification par mot de passe
force l'usage exclusif de clés SSH, ce qui élimine le risque de brute-force
ou de credential stuffing sur le service SSH exposé. Un mot de passe peut être
deviné, réutilisé d'une fuite de données, ou intercepté ; une paire de clés
asymétriques de 256+ bits n'est pas soumise aux mêmes attaques. C'est l'une
des mesures les plus efficaces contre les scans automatisés permanents sur le
port 22.)

## 6. Autres mesures de durcissement en production

(à rédiger : changer le port SSH par défaut, Fail2Ban / SSHGuard pour bannir
les IP après échecs répétés, authentification à 2 facteurs (TOTP), restriction
par `AllowUsers`/`AllowGroups`, VPN ou bastion host pour l'accès administratif,
mise à jour régulière du paquet openssh-server, surveillance centralisée des
logs (SIEM), désactivation des comptes inutilisés, principe du moindre
privilège sur sudo.)
