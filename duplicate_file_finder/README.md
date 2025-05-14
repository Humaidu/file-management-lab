# Duplicate File Finder - Bash Script

This is a simple, portable Bash script that scans a given directory for duplicate files based on file size and content (using SHA256 hash). It helps you clean up disk space by identifying and optionally deleting or moving duplicate files.

---

## Features

- Detects duplicate files using:
  - File size comparison (initial filtering)
  - SHA256 hash comparison (for content match)
- Offers options to:
  - Delete all but one copy
  - Move duplicates to a specified folder
  - Skip action
- Uses only basic Unix tools (no external dependencies)
- Works on Linux and macOS (POSIX-compliant)

---

## How It Works

1. Scans the given directory for all regular files.
2. Groups files by size.
3. Computes SHA256 hashes only within each size group.
4. Identifies duplicates (same size and same hash).
5. Presents grouped duplicates to the user.
6. Asks the user whether to delete, move, or skip duplicates.

---

## Requirements

- Bash 
- Standard utilities: `find`, `stat`, `sha256sum`, `awk`, `sort`, `rm`, `mv`

> ℹ️ On macOS, use `gsha256sum` (via `brew install coreutils`) if `sha256sum` is not available.

---

## Usage

*1. Make the script executable*
```
chmod +x duplicate_file_finder.sh

```
*2. Run the Script*
```
./duplicate_file_finder.sh <directory> [options]

```
---

## Example

```
$ ./duplicate_file_finder.sh ~/Downloads

Scanning directory: /Users/yourname/Downloads

Duplicate files found:

Group 1:
/Users/yourname/Downloads/copy1.txt
/Users/yourname/Downloads/duplicate_copy.txt

Group 2:
/Users/yourname/Downloads/image1.jpg
/Users/yourname/Downloads/image1 (1).jpg

Would you like to delete (d), move (m), or skip (s) duplicate files? [d/m/s]: m
Enter directory to move duplicates to: /Users/yourname/Duplicates
Moving: /Users/yourname/Downloads/duplicate_copy.txt to /Users/yourname/Duplicates
Moving: /Users/yourname/Downloads/image1 (1).jpg to /Users/yourname/Duplicates
Done.

```
---

## Script Behavior

- For each group of duplicates, the first file is kept.
- All other matching files are either deleted or moved, based on user choice.
- No files are deleted or moved without explicit confirmation.

---

## Cleanup

The script uses temporary files to store intermediate data. These are automatically deleted when the script exits.

---

## Notes
- Works recursively through all subdirectories of the given path.
- Symbolic links are ignored.
- Large files may take a bit longer due to hashing.