#!/bin/bash

# ================================================================
# File Sync Utility
# Description:
# Develops a program to keep files in sync between two folders.
# Implements a two-way synchronization and handle conflict resolution.
# ================================================================

#!/bin/bash

# Two-way file sync between DIR1 and DIR2
# Usage: ./file_sync.sh /path/to/dir1 /path/to/dir2

# Check args
if [ $# -ne 2 ]; then
  echo "Usage: $0 DIR1 DIR2"
  exit 1
fi

DIR1="$1"
DIR2="$2"

LOGFILE="file_sync.log"

# Basic logging function
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}

# Check if directories exist
if [ ! -d "$DIR1" ]; then
  echo "Directory $DIR1 does not exist!"
  exit 1
fi

if [ ! -d "$DIR2" ]; then
  echo "Directory $DIR2 does not exist!"
  exit 1
fi

# Detect platform for stat command
if stat --version >/dev/null 2>&1; then
  # GNU stat (Linux)
  STAT_CMD="stat -c %Y"
else
  # BSD stat (macOS)
  STAT_CMD="stat -f %m"
fi

log "Starting sync between $DIR1 and $DIR2"

# Function to sync from SRC to DEST
sync_files() {
  local SRC="$1"
  local DEST="$2"

  # Loop over files in SRC directory
  find "$SRC" -type f | while read -r SRCFILE; do
    # Get relative path of file wrt SRC dir
    RELPATH="${SRCFILE#$SRC/}"

    DESTFILE="$DEST/$RELPATH"

    # If file does not exist in DEST, copy it
    if [ ! -f "$DESTFILE" ]; then
      mkdir -p "$(dirname "$DESTFILE")"
      cp -p "$SRCFILE" "$DESTFILE"
      log "Copied new file $RELPATH from $SRC to $DEST"
    else
      # If file exists in DEST, compare modification times
      SRC_MOD=$($STAT_CMD "$SRCFILE")
      DEST_MOD=$($STAT_CMD "$DESTFILE")

      if [ "$SRC_MOD" -gt "$DEST_MOD" ]; then
        # SRC is newer -> overwrite DEST
        cp -p "$SRCFILE" "$DESTFILE"
        log "Updated file $RELPATH in $DEST from newer version in $SRC"
      elif [ "$SRC_MOD" -lt "$DEST_MOD" ]; then
        # DEST is newer -> conflict, skip and log
        log "Conflict for $RELPATH: destination file is newer, skipping copy from $SRC"
      else
        # Same mod time - no action needed
        :
      fi
    fi
  done
}

# Sync DIR1 -> DIR2
sync_files "$DIR1" "$DIR2"

# Sync DIR2 -> DIR1
sync_files "$DIR2" "$DIR1"

log "Sync finished."
