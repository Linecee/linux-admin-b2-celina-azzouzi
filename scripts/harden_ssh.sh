#!/bin/bash
#
# harden_ssh.sh
# Auteur      : Celina
# Date        : (à remplir le jour J)
# Description : Durcit /etc/ssh/sshd_config (sauvegarde auto, application des
#               règles, validation syntaxe avec rollback automatique si erreur).
#               NE redémarre PAS sshd automatiquement (à faire manuellement
#               après vérification, depuis une 2e session SSH déjà ouverte).
# Usage       : sudo ./harden_ssh.sh
#
set -euo pipefail

if [[ "$EUID" -ne 0 ]]; then
    echo "Erreur : ce script doit être exécuté en root (sudo)." >&2
    exit 1
fi

SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP="${SSHD_CONFIG}.bak.$(date +%Y%m%d)"

# --- Sauvegarde ---
echo "== Sauvegarde de la configuration actuelle =="
cp "$SSHD_CONFIG" "$BACKUP"
echo "Sauvegarde créée : $BACKUP"

# --- Paramètres à appliquer ---
declare -A SETTINGS=(
    [PermitRootLogin]="no"
    [PasswordAuthentication]="no"
    [PubkeyAuthentication]="yes"
    [MaxAuthTries]="3"
    [LoginGraceTime]="20"
    [ClientAliveInterval]="300"
    [ClientAliveCountMax]="2"
    [X11Forwarding]="no"
)

echo "== Application des paramètres =="
for key in "${!SETTINGS[@]}"; do
    value="${SETTINGS[$key]}"
    if grep -qE "^[#[:space:]]*${key}[[:space:]]" "$SSHD_CONFIG"; then
        sed -i -E "s|^[#[:space:]]*${key}[[:space:]].*|${key} ${value}|" "$SSHD_CONFIG"
    else
        echo "${key} ${value}" >> "$SSHD_CONFIG"
    fi
    echo "  $key -> $value"
done

# --- Validation syntaxe avec rollback automatique ---
echo "== Validation de la syntaxe (sshd -t) =="
if sshd -t; then
    echo "Configuration valide."
else
    echo "Erreur de syntaxe détectée ! Restauration de la sauvegarde..." >&2
    cp "$BACKUP" "$SSHD_CONFIG"
    exit 1
fi

# --- Diff ---
echo
echo "===== DIFF (ancienne vs nouvelle config) ====="
diff "$BACKUP" "$SSHD_CONFIG" || true
echo "================================================"

# --- Pas de restart automatique ---
echo
echo "⚠️  La configuration a été mise à jour mais sshd N'A PAS été redémarré."
echo "    Gardez votre session SSH actuelle ouverte, vérifiez la config,"
echo "    puis dans une AUTRE session lancez :"
echo "      sudo systemctl restart sshd"
echo "    et testez une nouvelle connexion avant de fermer la première."
