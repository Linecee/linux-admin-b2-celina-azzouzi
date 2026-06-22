#!/bin/bash
# ============================================================
# Script  : logwatcher.sh
# Auteur  : Celina AZZOUZI
# Date    : 2026-06-20
# Desc    : Surveillance des tentatives de connexion SSH
# Usage   : Lancé par le service systemd logwatcher.service
# ============================================================

# === Variables ===============================================
AUTH_LOG="/var/log/auth.log"    # adapter si /var/log/secure (RHEL)
LOG_DIR="/var/log/logwatcher"
LOG_FILE="$LOG_DIR/activity.log"
INTERVAL=30                      # secondes entre chaque cycle
SEUIL=5                          # seuil d'alerte

# === Initialisation ==========================================
# Créer LOG_DIR si absent (mkdir -p)
if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR"
fi

# Compteur de base (nombre de lignes au démarrage)
LAST_COUNT=$(grep -c -E "Failed password|Invalid user" "$AUTH_LOG" 2>/dev/null || echo 0)

# === Boucle principale =======================================
while true; do

    TIMESTAMP=$(date '+%H:%M:%S')
    DATE=$(date '+%Y-%m-%d %H:%M:%S')

    # Compter le total de tentatives échouées dans AUTH_LOG
    TOTAL=$(grep -c -E "Failed password|Invalid user" "$AUTH_LOG" 2>/dev/null || echo 0)

    # Calculer le nombre de NOUVELLES tentatives depuis le cycle précédent
    if [ "$TOTAL" -ge "$LAST_COUNT" ]; then
        NOUVELLES=$((TOTAL - LAST_COUNT))
    else
        # Gère le cas d'une rotation de logs (logrotate)
        NOUVELLES=$TOTAL
    fi

    # Mettre à jour le compteur de référence
    LAST_COUNT=$TOTAL

    # Écrire dans journald via stderr (capturé par systemd)
    echo "[LOGWATCHER] $NOUVELLES tentative(s) SSH échouée(s) — $TIMESTAMP" >&2

    # Si NOUVELLES > SEUIL, écrire un message d'alerte dans journald
    if [ "$NOUVELLES" -gt "$SEUIL" ]; then
        echo "[LOGWATCHER] [ALERTE] Pic suspect : $NOUVELLES tentatives." >&2
    fi

    # Écrire dans LOG_FILE
    echo "$DATE | Nouvelles: $NOUVELLES | Total: $TOTAL" >> "$LOG_FILE"

    sleep $INTERVAL

done
