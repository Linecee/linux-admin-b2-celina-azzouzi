#!/bin/bash
# ============================================================
# Script  : harden_ssh.sh
# Auteur  : Celina AZZOUZI
# Date    : 2026-06-22
# Desc    : Durcissement de la configuration SSH
# Usage   : sudo ./scripts/harden_ssh.sh
# ⚠  IMPORTANT : Ayez une deuxième session SSH ouverte
#                avant d'exécuter ce script !
# ============================================================

# === Vérification root =======================================
# TODO : vérifier root, exit 1 sinon
if [[ "$EUID" -ne 0 ]]; then
    echo "Erreur : ce script doit être exécuté en root (sudo)." >&2
    exit 1
fi

# === Variables ===============================================
SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP="$SSHD_CONFIG.bak.$(date +%Y%m%d)"


# === Sauvegarde ==============================================
echo "[INFO] Sauvegarde de $SSHD_CONFIG → $BACKUP"
# TODO : copier sshd_config vers $BACKUP
cp "$SSHD_CONFIG" "$BACKUP"


# === Fonction de restauration ================================
restore_and_exit() {
    echo "[ERREUR] La configuration SSH est invalide." >&2
    echo "[INFO] Restauration de la sauvegarde..." >&2
    # TODO : restaurer $BACKUP vers $SSHD_CONFIG
    cp "$BACKUP" "$SSHD_CONFIG"
    echo "[INFO] Sauvegarde restaurée. Aucune modification appliquée." >&2
    exit 1
}


# === Application des directives ==============================
# Fonction utilitaire : modifier ou ajouter une directive dans sshd_config
set_directive() {
    local key="$1"
    local value="$2"
    # TODO : si la directive (commentée ou non) existe, la remplacer
    #        sinon, l'ajouter à la fin du fichier
    #        Utiliser sed -i pour la modification en place
    if grep -q -E "^#?${key}" "$SSHD_CONFIG"; then
        sed -i "s/^#\?${key}.*/${key} ${value}/" "$SSHD_CONFIG"
    else
        echo "${key} ${value}" >> "$SSHD_CONFIG"
    fi
}

echo "[INFO] Application des directives de sécurité..."

# TODO : appeler set_directive pour chaque paramètre :
# PermitRootLogin       no
# PasswordAuthentication no
# PubkeyAuthentication  yes
# MaxAuthTries          3
# LoginGraceTime        20
# ClientAliveInterval   300
# ClientAliveCountMax   2
# X11Forwarding         no
set_directive "PermitRootLogin" "no"
set_directive "PasswordAuthentication" "no"
set_directive "PubkeyAuthentication" "yes"
set_directive "MaxAuthTries" "3"
set_directive "LoginGraceTime" "20"
set_directive "ClientAliveInterval" "300"
set_directive "ClientAliveCountMax" "2"
set_directive "X11Forwarding" "no"


# === Validation ==============================================
echo "[INFO] Validation de la syntaxe..."
# TODO : lancer sshd -t
#        Si le code retour est non nul, appeler restore_and_exit
sshd -t
if [ $? -ne 0 ]; then
    restore_and_exit
fi


# === Résumé des modifications ================================
echo ""
echo "============================================================"
echo " Modifications appliquées (diff)"
echo "============================================================"
# TODO : afficher le diff entre $BACKUP et $SSHD_CONFIG
diff "$BACKUP" "$SSHD_CONFIG"


# === Message final ===========================================
echo ""
echo "============================================================"
echo " ✅ Configuration validée — sshd NON redémarré"
echo "============================================================"
echo " Vérifiez votre connexion SSH depuis un autre terminal,"
echo " puis redémarrez manuellement avec :"
echo "   sudo systemctl restart ssh"
echo "============================================================"