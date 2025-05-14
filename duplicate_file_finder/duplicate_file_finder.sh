#!/bin/bash

# ================================================================
# Duplicate File Finder
# Description: Make a script to find and list duplicate files in a folder.
# Use file size and content comparison to spot duplicates 
# and offer choices to delete or move them.
# ================================================================

# Get the target directory from argument, default to current directory if none is given
TARGET_DIR="${1:-.}"

# Temp files to store intermediate data
TEMP_ALL_FILES=$(mktemp)
TEMP_GROUPED=$(mktemp)
TEMP_DUPLICATES=$(mktemp)
TEMP_ACTION=$(mktemp)

# Clean up temp files on exit
cleanup() {
    rm -f "$TEMP_ALL_FILES" "$TEMP_GROUPED" "$TEMP_DUPLICATES" "$TEMP_ACTION"
}
trap cleanup EXIT

echo "Scanning directory: $TARGET_DIR"
echo

# Step 1: Find all files and list their size and path
# Output format: SIZE|FULL_PATH
find "$TARGET_DIR" -type f -exec stat -c "%s|%n" {} + > "$TEMP_ALL_FILES"

# Step 2: Sort by size to group files of the same size
sort -n "$TEMP_ALL_FILES" > "$TEMP_GROUPED"

# Step 3: For each group of same size, compute hashes and look for duplicates
prev_size=""
> "$TEMP_DUPLICATES"

while IFS='|' read -r size filepath; do
    if [ "$size" != "$prev_size" ]; then
        # New file size group
        declare -A hash_map
        unset hash_map
        prev_size="$size"
    fi

    # Compute SHA256 hash
    hash=$(sha256sum "$filepath" | awk '{print $1}')

    # Use temp file to track duplicates manually (no arrays)
    echo "$size|$hash|$filepath" >> "$TEMP_ACTION"

done < "$TEMP_GROUPED"

# Group by size and hash to find duplicates
sort "$TEMP_ACTION" | awk -F'|' '
{
    key = $1 "|" $2
    file_map[key] = (file_map[key] ? file_map[key] RS $3 : $3)
    count[key]++
}
END {
    index = 1
    for (k in file_map) {
        if (count[k] > 1) {
            print "Group " index ":"
            print file_map[k]
            print ""
            print file_map[k] >> "'$TEMP_DUPLICATES'"
            print "" >> "'$TEMP_DUPLICATES'"
            index++
        }
    }
}
'

# Step 4: Handle duplicates
if [ ! -s "$TEMP_DUPLICATES" ]; then
    echo "No duplicates found."
    exit 0
fi

echo "Duplicate files found."

echo
read -p "Would you like to delete (d), move (m), or skip (s) duplicate files? [d/m/s]: " action

if [[ "$action" == "d" || "$action" == "m" ]]; then
    if [ "$action" == "m" ]; then
        read -p "Enter directory to move duplicates to: " move_dir
        mkdir -p "$move_dir"
    fi

    # Read each duplicate group and process files
    while read -r line; do
        if [ -z "$line" ]; then
            unset keep
            continue
        fi

        if [ -z "$keep" ]; then
            # First file in group, keep it
            keep="$line"
            continue
        fi

        if [ "$action" == "d" ]; then
            echo "Deleting: $line"
            rm -f "$line"
        else
            echo "Moving: $line to $move_dir"
            mv "$line" "$move_dir/"
        fi
    done < "$TEMP_DUPLICATES"

    echo "Done."
else
    echo "No action taken."
fi