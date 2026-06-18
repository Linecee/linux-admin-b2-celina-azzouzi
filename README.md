# Devoir Administration Linux B2 — Promotion 2025/2026

**Nom / Prénom :** (à compléter)
**Niveau :** B2 Bachelor Informatique, 2e année
**Date :** (à compléter)

## Résumé des missions

- **M1** — Mise en place du dépôt GitHub avec structure conforme et commits réguliers.
- **M2** — Création automatisée des groupes `devteam`/`ops` et des utilisateurs `alice`/`bob`/`charlie` via un script idempotent.
- **M3** — Mise en place de `/srv/devproject` avec permissions, SGID, sticky bit et ACL pour `charlie` sur `docs/`.
- **M4** — Service systemd `logwatcher` qui surveille les tentatives SSH échouées et log dans journald + fichier.
- **M5** — Durcissement de la configuration SSH (sauvegarde auto, validation, pas de restart auto) et configuration du pare-feu UFW.

## Prérequis pour exécuter les scripts

- Distribution : Ubuntu/Debian (testé sur **[à compléter, ex: Ubuntu 22.04]**)
- Accès root (sudo)
- Paquets nécessaires : `acl` (pour `setfacl`/`getfacl`), `ufw`, `openssh-server`
  ```bash
  sudo apt update && sudo apt install -y acl ufw openssh-server
  ```

## Statut

| Mission | Description                          | Statut | Points estimés |
|---------|---------------------------------------|--------|-----------------|
| M1      | Mise en place du dépôt GitHub          | ⚠️     | /10              |
| M2      | Gestion des utilisateurs & groupes     | ⚠️     | /20              |
| M3      | Système de fichiers & permissions      | ⚠️     | /20              |
| M4      | Service systemd custom                 | ⚠️     | /20              |
| M5      | Sécurisation SSH & pare-feu            | ⚠️     | /20              |
| Bonus   | (optionnel)                            | ⚠️     | /10              |

> Mettre à jour les statuts (✅ / ⚠️ / ❌) au fur et à mesure de l'avancement.
