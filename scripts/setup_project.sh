#!/bin/bash
#
# setup_project.sh
# Auteur      : Celina
# Date        : (à remplir le jour J)
# Description : Crée l'arborescence /srv/devproject (src, docs, releases, logs)
#               avec permissions, SGID + sticky bit sur src/docs, et ACL pour
#               charlie en lecture sur docs/.
# Prérequis   : Mission 2 déjà exécutée (groupes devteam/ops, users alice/bob/charlie).
# Usage       : sudo ./setup_project.sh
#
set -euo pipefail

if [[ "$EUID" -ne 0 ]]; then
    echo "Erreur : ce script doit être exécuté en root (sudo)." >&2
    exit 1
fi

BASE_DIR="/srv/devproject"
GROUP="devteam"

declare -A DIRS=(
    [src]="770"
    [docs]="770"
    [releases]="750"
    [logs]="700"
)

# --- Création de l'arborescence ---
echo "== Création de l'arborescence =="
mkdir -p "$BASE_DIR"
for d in "${!DIRS[@]}"; do
    mkdir -p "$BASE_DIR/$d"
    echo "Dossier $BASE_DIR/$d prêt."
done

# --- Permissions et propriétaires ---
echo "== Application des permissions et propriétaires =="
for d in "${!DIRS[@]}"; do
    perm="${DIRS[$d]}"
    if [[ "$d" == "logs" ]]; then
        chown root:root "$BASE_DIR/$d"
    else
        chown root:"$GROUP" "$BASE_DIR/$d"
    fi
    chmod "$perm" "$BASE_DIR/$d"
done

# --- SGID + sticky bit sur src/ et docs/ ---
echo "== SGID + sticky bit sur src/ et docs/ =="
for d in src docs; do
    chmod g+s "$BASE_DIR/$d"   # SGID : les nouveaux fichiers héritent du groupe devteam
    chmod +t "$BASE_DIR/$d"    # sticky bit : seul le propriétaire peut supprimer son fichier
done

# --- ACL pour charlie sur docs/ ---
echo "== ACL : charlie en lecture/exécution sur docs/ =="
setfacl -m u:charlie:r-x "$BASE_DIR/docs"

# --- Fichiers de test ---
echo "== Création de fichiers de test =="
for d in "${!DIRS[@]}"; do
    touch "$BASE_DIR/$d/test_${d}.txt"
done

# --- Récapitulatif ---
echo
echo "===== RÉCAPITULATIF ====="
ls -laR "$BASE_DIR"
echo "--- ACL sur docs/ ---"
getfacl "$BASE_DIR/docs"
echo "=========================="
