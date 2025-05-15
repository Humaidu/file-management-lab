#!/bin/bash

# =================================================================================
# Disk Space Analyzer
# Description:
# Write a tool to show which folders and files use the most space.
# Create a tree-like structure to display disk usage and offer options to sort and filter results.

# Usage: 
# ./disk_analyzer.sh [directory] [sort: largest|smallest|none] [min_size_mb]
# =================================================================================

#!/bin/bash

# Disk Space Analyzer - Simple & Portable (macOS/Linux)
# Usage: ./disk_analyzer.sh [directory] [sort: largest|smallest] [min_size_mb]

# Arguments
TARGET_DIR="${1:-.}"
SORT_TYPE="${2:-none}"
MIN_MB="${3:-0}"
MIN_KB=$((MIN_MB * 1024))

# Validate directory
if [ ! -d "$TARGET_DIR" ]; then
  echo "Directory not found: $TARGET_DIR"
  exit 1
fi

# Temporary file
TMP_FILE=$(mktemp)

# Gather sizes in kilobytes
du -ak "$TARGET_DIR" 2>/dev/null | tail -n +2 > "$TMP_FILE"

# Filter by min size
awk -v min="$MIN_KB" '$1 >= min' "$TMP_FILE" > "${TMP_FILE}_filtered"

# Sorting based on user input
if [ "$SORT_TYPE" = "largest" ]; then
  sort -nr "${TMP_FILE}_filtered" > "${TMP_FILE}_sorted"
elif [ "$SORT_TYPE" = "smallest" ]; then
  sort -n "${TMP_FILE}_filtered" > "${TMP_FILE}_sorted"
else
  cp "${TMP_FILE}_filtered" "${TMP_FILE}_sorted"
fi

# Tree-like display
while read -r size path; do
  # Remove trailing slash if any
  clean_path="${path%/}"

  # Remove the directory prefix and possible slash
  relative="${clean_path#$TARGET_DIR}"
  # If relative path starts with '/', remove it
  relative="${relative#/}"

  depth=$(echo "$relative" | awk -F"/" '{print NF-1}')
  indent=$(printf "  %.0s" $(seq 1 $depth))
  hr_size=$(awk "BEGIN {printf \"%.1fM\", $size/1024}")
  echo "${indent}- $hr_size  ${relative:-.}"
done < "${TMP_FILE}_sorted"

# Cleanup
rm -f "$TMP_FILE" "${TMP_FILE}_filtered" "${TMP_FILE}_sorted"