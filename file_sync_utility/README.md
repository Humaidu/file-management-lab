# File Sync Utility

A simple two-way file synchronization script written in Bash. This utility keeps files in sync between two directories, handling conflicts based on file modification times, and logging all operations.

---

## Features

- Two-way synchronization: keeps both directories updated.
- Copies new files and updates older files with newer versions.
- Basic conflict detection: if a destination file is newer, it skips overwriting and logs the conflict.
- Logs all actions with timestamps to both the terminal and a log file (`file_sync.log`).
- Compatible with Linux and macOS (auto-detects platform differences for file timestamps).
- Beginner-friendly and simple to understand.

---

## Requirements

- Bash shell
- Standard Unix utilities: `cp`, `find`, `mkdir`, `stat`, `date`
- Tested on Linux and macOS systems

---

## Usage

*1. Make the script executable*
```
chmod +x file_sync_utility.sh

```
*2. Run the script:*

```
./file_sync_utility.sh /path/to/directory1 /path/to/directory2

```

*3. The script will*:

- Synchronize files from directory1 to directory2 and then from directory2 to directory1.
- Print synchronization status messages to the terminal.
- Log all actions to file_sync.log in the current working directory.

---

## Examples

**Suppose you have two folders with different or updated files:**

```
./file_sync.sh ~/projects/dir1 ~/projects/dir2

```

**Terminal output might show:**

```
2025-05-15 14:12:45 - Starting sync between /Users/humaidu/projects/dir1 and /Users/humaidu/projects/dir2
2025-05-15 14:12:45 - Copied new file notes.txt from /Users/humaidu/projects/dir1 to /Users/humaidu/projects/dir2
2025-05-15 14:12:45 - Conflict for report.pdf: destination file is newer, skipping copy from /Users/humaidu/projects/dir1
2025-05-15 14:12:46 - Sync finished.

```

---

## How It Works

- The script scans all files (recursively) in each source directory.
- For each file, it checks if the corresponding file exists in the destination directory.
- If missing, it copies the file.
- If present, it compares modification times:
    - If the source file is newer, it overwrites the destination file.
    - If the destination file is newer, it skips the copy and logs a conflict.
- This process happens both ways to ensure two-way sync.
- The script creates any needed directories in the destination as necessary.

---

## Conflict Handling

When a file exists in both directories but the destination file is newer than the source file, the script does not overwrite it. Instead, it logs a conflict message like:

```
YYYY-MM-DD HH:MM:SS - Conflict for path/to/file.txt: destination file is newer, skipping copy from /source/directory

```

---

## Log File

- All operations and conflicts are appended to a log file named file_sync.log in the current working directory.
- Log entries include timestamps for easy tracking.

```
cat file_sync.log

2025-05-15 14:20:47 - Starting sync between test_folder/dir1 and test_folder/dir2
2025-05-15 14:20:47 - Copied new file file4.sh from test_folder/dir1 to test_folder/dir2
2025-05-15 14:20:47 - Copied new file file1.txt from test_folder/dir2 to test_folder/dir1
2025-05-15 14:20:47 - Sync finished.

```

---

## Limitations & Notes

- The script only syncs regular files; it ignores directories themselves beyond creating them as needed.
- It does not delete files that are removed in one directory.
- It does not handle complex merge conflicts — skips overwriting if destination is newer.
- Designed for simplicity and clarity, not for heavy-duty or production use.
- Works best for small to medium-sized directories.


