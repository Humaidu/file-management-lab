#!/bin/bash

# ================================================================
# Bulk File Renamer
# Description:
#   This script renames all files in a given directory based on
#   user-defined rules such as adding prefixes, suffixes, counters,
#   and the current date. It uses if-elif-else for option parsing.
# ================================================================

# Check if a directory is given
if [ -z "$1" ]; then
  echo "Usage: $0 <directory> [prefix=...] [suffix=...] [counter] [start=N] [date]"
  exit 1
fi

# Set the target directory 
TARGET_DIR="$1"
# Remove the first argument so remaining ones can be parsed
shift  

# Initialize default values
PREFIX=""
SUFFIX=""
USE_COUNTER=false
COUNTER_START=1
USE_DATE=false

# Parse optional arguments 
for arg in "$@"; do
  if [[ $arg == prefix=* ]]; then
    PREFIX="${arg#prefix=}"        # Extract value after 'prefix='
  elif [[ $arg == suffix=* ]]; then
    SUFFIX="${arg#suffix=}"        # Extract value after 'suffix='
  elif [[ $arg == counter ]]; then
    USE_COUNTER=true               # Enable counter flag
  elif [[ $arg == start=* ]]; then
    COUNTER_START="${arg#start=}"  # Extract value after 'start='
  elif [[ $arg == date ]]; then
    USE_DATE=true                  # Enable date flag
  else
    echo "Unknown option: $arg"    # Warn on unrecognized option
  fi
done

# Check if directory exists and change to target directory
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Directory not found - $TARGET_DIR"
  exit 1
else
    cd "$TARGET_DIR" 
fi

# Initialize counter value
COUNT=$COUNTER_START

# Loop through files in folder
for FILE in *; do
  # Skip non-regular files
  [ -f "$FILE" ] || continue

  # Extract file extension and base name
  EXT="${FILE##*.}"         
  BASENAME="${FILE%.*}"    

  # Start building new file name
  NEWNAME="${PREFIX}${BASENAME}"

  # Append counter if enabled
  if $USE_COUNTER; then
    NEWNAME="${NEWNAME}_$COUNT"
  fi

  # Append date if enabled
  if $USE_DATE; then
    DATESTR=$(date +%Y%m%d)
    NEWNAME="${NEWNAME}_$DATESTR"
  fi

  # Append suffix and extension
  NEWNAME="${NEWNAME}${SUFFIX}.${EXT}"

  # Rename the file safely (-i prompts if file exists)
  mv -i "$FILE" "$NEWNAME"

  # Increment counter
  ((COUNT++))
done

echo "Renaming complete."
