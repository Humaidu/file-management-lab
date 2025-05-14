#!/bin/bash

# ================================================================
# Duplicate File Finder
# Description: Make a script to find and list duplicate files in a folder.
# Use file size and content comparison to spot duplicates 
# and offer choices to delete or move them.
# ================================================================

# Get the target directory from argument, default to current directory if none is given
TARGET_DIR="${1:-.}"

# Create temporary files to store intermediate data
TEMP_ALL_FILES=$(mktemp)   # Stores size|path for all files
TEMP_GROUPED=$(mktemp)     # Sorted version of above
TEMP_ACTION=$(mktemp)      # size|hash|path for further grouping
TEMP_DUPLICATES=$(mktemp)    # Stores paths of detected duplicates

cleanup() {
    rm -f "$TEMP_ALL_FILES" "$TEMP_GROUPED" "$TEMP_ACTION" "$TEMP_DUPLICATES"
}
trap cleanup EXIT

# Detect operating system to set correct commands
OS=$(uname)
if [[ "$OS" == "Darwin" ]]; then
    # macOS: use stat -f and shasum
    STAT_CMD='stat -f "%z|%N"'
    HASH_CMD='shasum -a 256'
else
    # Linux: use stat -c and sha256sum
    STAT_CMD='stat -c "%s|%n"'
    HASH_CMD='sha256sum'
fi

echo "Scanning directory: $TARGET_DIR"
echo

# List all files with size and path
# Safely handle spaces/newlines with null-delimited input
while IFS= read -r -d '' file; do
    size=$(eval $STAT_CMD "\"$file\"" | cut -d'|' -f1)
    echo "$size|$file"
done < <(find "$TARGET_DIR" -type f -print0) > "$TEMP_ALL_FILES"

# Sort by file size to group potentially duplicate files
sort -n "$TEMP_ALL_FILES" > "$TEMP_GROUPED"

# For each group with same size, compute hashes
# We assume files of different sizes cannot be duplicates

prev_size=""
> "$TEMP_ACTION"  #Clear the temp action file

while IFS='|' read -r size filepath; do
    if [ "$size" != "$prev_size" ]; then
        # New file size group
        prev_size="$size"
    fi

    if [ -f "$filepath" ]; then
        # Compute hash of the file
        hash=$($HASH_CMD "$filepath" | awk '{print $1}')
        # Save size|hash|filepath to next processing stage
        echo "$size|$hash|$filepath" >> "$TEMP_ACTION"
    fi
done < "$TEMP_GROUPED"

# Group by size and hash to find duplicates
# Using awk to collect file paths for identical files
sort "$TEMP_ACTION" | awk -F'|' '
{
    key = $1 "|" $2
    files[key] = (files[key] ? files[key] "\n" $3 : $3)
    count[key]++
}
END {
    group = 1
    for (k in files) {
        if (count[k] > 1) {
            print "Group " group ":"
            print files[k]
            print ""
            print files[k] >> "'$TEMP_DUPLICATES'"
            print "" >> "'$TEMP_DUPLICATES'"
            group++
        }
    }
}
'

# If no duplicates found, exit
if [ ! -s "$TEMP_DUPLICATES" ]; then
    echo "No duplicates found."
    exit 0
fi

# Step 6: Prompt user for action
echo "Duplicate files found."
read -p "Would you like to delete (d), move (m), or skip (s) duplicate files? [d/m/s]: " action

if [[ "$action" == "d" || "$action" == "m" ]]; then
    if [[ "$action" == "m" ]]; then
        read -p "Enter directory to move duplicates to: " move_dir
        mkdir -p "$move_dir"
    fi

    # Go through the list of duplicates
    while read -r line; do
        if [ -z "$line" ]; then
            # Empty line marks the start of a new group
            unset keep
            continue
        fi

        if [ -z "$keep" ]; then
            # Keep the first file in each group
            keep="$line"
            continue
        fi

        if [[ "$action" == "d" ]]; then
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