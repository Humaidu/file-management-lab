#!/bin/bash

# ================================================================
# File Backup System
# Description:
# - Creates full or partial backups from a user-defined source directory
# - Supports optional destination directory (default: $HOME/backups)
# - Backup file names reflect folder (full) or file names (partial)
# - Backups are compressed with tar.gz by default
# ================================================================



# === DEFAULT CONFIGURATION ===
BACKUP_DIR="$HOME/backups"      # Default destination
MODE="full"                     # Default backup mode
INCLUDE_LIST=()
COMPRESS=true

# === HELP MESSAGE ===
usage() {
  echo "Usage: $0 -s source_dir [-d backup_dir] [-p file1,file2,...] [-m full|partial] [-z yes|no]"
  echo ""
  echo "Options:"
  echo " -s Source directory to back up (required for full and partial)"
  echo " -d Destination directory to store backup (default: $HOME/backups)"
  echo " -p Comma-separated list of files for partial backup"
  echo " -m Backup mode: full or partial (default: full)"
  echo " -z Compress the backup: yes (default) or no"
  echo " -h Show this help message"
  exit 1
}

# === PARSE ARGUMENTS ===
while getopts "s:d:p:m:z:h" opt; do
  case "$opt" in
    s) SRC_DIR="$OPTARG" ;;
    d) BACKUP_DIR="$OPTARG" ;;
    p)
      IFS=',' read -ra INCLUDE_LIST <<< "$OPTARG"
      PARTIAL_FILES="$OPTARG"
      MODE="partial"
      ;;
    m) MODE="$OPTARG" ;;
    z) [[ "$OPTARG" == "no" ]] && COMPRESS=false ;;
    h) usage ;;
    *) usage ;;
  esac
done

# === VALIDATION ===
if [[ -z "$SRC_DIR" ]]; then
  echo "Error: Source directory (-s) is required."
  usage
fi

if [[ ! -d "$SRC_DIR" ]]; then
  echo "Error: Source directory '$SRC_DIR' does not exist."
  exit 1
fi

# === CREATE BACKUP NAME ===
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)

if [[ "$MODE" == "partial" && ${#INCLUDE_LIST[@]} -gt 0 ]]; then
  JOINED_NAMES=$(IFS=; echo "${INCLUDE_LIST[*]}")
  SANITIZED_NAMES=$(echo "$JOINED_NAMES" | tr -cd '[:alnum:]')
  BACKUP_NAME="${SANITIZED_NAMES}_${TIMESTAMP}"
else
  SOURCE_BASENAME=$(basename "$SRC_DIR")
  BACKUP_NAME="${SOURCE_BASENAME}_${TIMESTAMP}"
fi

echo "Backup will be named: $BACKUP_NAME"

# === CREATE DESTINATION FOLDER IF NOT EXISTS ===
mkdir -p "$BACKUP_DIR"

# === PREPARE BACKUP CONTENT ===
if [[ "$MODE" == "full" ]]; then
  TARGET="$SRC_DIR"
elif [[ "$MODE" == "partial" && ${#INCLUDE_LIST[@]} -gt 0 ]]; then
  TMP_DIR="/tmp/$BACKUP_NAME"
  mkdir -p "$TMP_DIR"
  for item in "${INCLUDE_LIST[@]}"; do
    if [[ -e "$SRC_DIR/$item" ]]; then
      cp -r "$SRC_DIR/$item" "$TMP_DIR/"
    else
      echo "Warning: '$item' not found in $SRC_DIR"
    fi
  done
  TARGET="$TMP_DIR"
else
  echo "Error: Invalid mode or no files specified for partial backup."
  exit 1
fi

# === PERFORM BACKUP ===
if $COMPRESS; then
  tar -czf "$BACKUP_DIR/$BACKUP_NAME.tar.gz" -C "$(dirname "$TARGET")" "$(basename "$TARGET")"
  echo "Backup completed: $BACKUP_DIR/$BACKUP_NAME.tar.gz"
else
  cp -r "$TARGET" "$BACKUP_DIR/$BACKUP_NAME"
  echo "Backup completed: $BACKUP_DIR/$BACKUP_NAME"
fi

# === CLEAN UP TEMP DIR ===
[[ "$MODE" == "partial" && -d "$TMP_DIR" ]] && rm -rf "$TMP_DIR"
