#!/bin/bash

# ===============================================================================
# Automatic File Sorter
# Description: Create a script that organizes files in a folder based on their types. The script should scan a directory, find file extensions, and move files into suitable subfolders (e.g., Documents,Images, Videos).
# ===============================================================================

# Check if directory is given
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/directory"
    exit 1
fi

# cd(change directory) into the target directory if it exists
TARGET_DIR="$1"
if [[ -d "$TARGET_DIR" ]]; then
    cd "$TARGET_DIR"
else
    echo "Directory not found."
    exit 1
fi

# Loop through all files with extensions
for file in *.*; do
    # skip non-regular files.
    if [ ! -f "$file" ]; then
    continue
    fi

    # Extract the extension from the filename 
    ext="${file##*.}"
    # convert to lowercase
    ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]') 

   # Determine the category
    case "$ext" in
        pdf|doc|docx|txt|xls|xlsx|ppt|pptx|odt)
            category="Documents"
            ;;
        jpg|jpeg|png|gif|bmp|svg|heic)
            category="Images"
            ;;
        mp4|mkv|avi|mov|wmv|flv)
            category="Videos"
            ;;
        mp3|wav|ogg|m4a|flac)
            category="Music"
            ;;
        zip|tar|gz|rar|7z|bz2)
            category="Archives"
            ;;
        sh|py|js|rb|php)
            category="Scripts"
            ;;
        *)
            category="Others"
            ;;
    esac

    # Create categorized folder if it doesn't exist
    if [[ ! -d "$category" ]]; then
        mkdir "$category"
    fi

    # Move file to matching categorized folder
    mv "$file" "$category/"
done

echo "Files organized successfully in '$TARGET_DIR'."
