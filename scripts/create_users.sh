#!/bin/bash
# ============================================================
# Script  : create_users.sh
# Auteur  : Celina AZZOUZI
# Date    : 2026-06-19
# Desc    : Création automatisée des comptes équipe dev
# Usage   : sudo ./scripts/create_users.sh
# ============================================================

# === Vérification root =======================================
if [[ "$EUID" -ne 0 ]]; then
    echo "Erreur : ce script doit être exécuté en root (sudo)." >&2
    exit 1
fi

# === Variables ===============================================
GROUPE_DEV="devteam"
GID_DEV=3001
GROUPE_OPS="ops"
GID_OPS=3002

USER1="alice"
UID1=2001
USER2="bob"
UID2=2002
USER3="charlie"
UID3=2003

PROJET_DIR="/opt/devproject"
MDP_TEMP="ChangeMe123!"

# === Création des groupes ====================================
if getent group "$GROUPE_DEV" >/dev/null; then
    echo "Groupe $GROUPE_DEV existe déjà."
else
    groupadd -g "$GID_DEV" "$GROUPE_DEV"
    echo "Groupe $GROUPE_DEV créé (GID $GID_DEV)."
fi

if getent group "$GROUPE_OPS" >/dev/null; then
    echo "Groupe $GROUPE_OPS existe déjà."
else
    groupadd -g "$GID_OPS" "$GROUPE_OPS"
    echo "Groupe $GROUPE_OPS créé (GID $GID_OPS)."
fi

# === Création des utilisateurs ===============================
if id "$USER1" &>/dev/null; then
    echo "Utilisateur $USER1 existe déjà."
else
    useradd -m -s /bin/bash -u "$UID1" -g "$GROUPE_DEV" "$USER1"
    echo "Utilisateur $USER1 créé (UID $UID1)."
fi

if id "$USER2" &>/dev/null; then
    echo "Utilisateur $USER2 existe déjà."
else
    useradd -m -s /bin/bash -u "$UID2" -g "$GROUPE_DEV" "$USER2"
    echo "Utilisateur $USER2 créé (UID $UID2)."
fi

if id "$USER3" &>/dev/null; then
    echo "Utilisateur $USER3 existe déjà."
else
    useradd -m -s /bin/bash -u "$UID3" -g "$GROUPE_OPS" "$USER3"
    echo "Utilisateur $USER3 créé (UID $UID3)."
fi

# === Groupes secondaires =====================================
usermod -aG "$GROUPE_OPS" "$USER1"
echo "$USER1 ajouté au groupe $GROUPE_OPS."

# === Mots de passe temporaires ===============================
for user in "$USER1" "$USER2" "$USER3"; do
    echo "$user:$MDP_TEMP" | chpasswd
    chage -d 0 "$user"
done
echo "Mots de passe temporaires définis, changement forcé au 1er login."

# === Répertoire projet =======================================
mkdir -p "$PROJET_DIR"
chown root:"$GROUPE_DEV" "$PROJET_DIR"
chmod 770 "$PROJET_DIR"

# === Récapitulatif ===========================================
echo ""
echo "============================================================"
echo " Récapitulatif de création"
echo "============================================================"
id "$USER1"
id "$USER2"
id "$USER3"
ls -ld "$PROJET_DIR"
