# File Backup System (Bash Script)

A simple and portable Bash script to back up important files and directories. This tool supports full and partial backups, optional compression, and is easy to schedule via cron. It works on most Unix-like systems (Linux, macOS, WSL).

---

## 📌 Features

- **Full backups:** Back up an entire directory.
- **Partial backups:** Back up selected files or folders inside a source directory.
- **Compression:** Creates compressed `.tar.gz` archives by default.
- **Customizable:** Specify source and destination directories.
- **Automatic naming:** Backup filenames include folder or file names plus a timestamp.

---

## Requirements

- bash (preinstalled on most Unix systems)
- tar and gzip (for compression)
- mkdir, cp, date (coreutils, usually available)

---

## Usage

*1. Make the script executable*
```
chmod +x file_backup_system.sh

```
*2. Run the Script*
```
./file_backup_system.sh -s source_dir [-d backup_dir] [-p file1,file2,...] [-m full|partial] [-z yes|no]

```

---

## Command-Line Options

| Flag | Description                                              | Default        | Required?            |
| ---- | -------------------------------------------------------- | -------------- | -------------------- |
| -s   | Source directory to back up                              | No default     | Required             |
| -d   | Destination directory to store backup                    | \$HOME/backups | Optional             |
| -p   | Comma-separated list of files/folders for partial backup | None           | Required for partial |
| -m   | Backup mode: full or partial                             | full           | Optional             |
| -z   | Compress backup archive: yes or no                       | yes (compress) | Optional             |
| -h   | Show help message                                        | —              | Optional             |

---

##  Examples

**1. Full backup of a directory (required to specify source):**

```
./file_backup_system.sh -s ~/Documents

```

**2. Full backup with custom destination directory:**

```
../file_backup_system.sh -s ~/Projects -d ~/my_backups

```

**3. Partial backup (selected files or folders inside source):**

```
./file_backup_system.sh -s ~/Documents -p "file1.txt,file2.txt"

```

**4. Full backup without compression:**

```
./file_backup_system.sh -s ~/Documents -p "file1.txt,file2.txt" -z no

```

---

## Backup Naming Convention ##
- **Full backup:** Uses the basename of the source directory plus a timestamp.
Example: Documents_2025-05-15_09-00-00.tar.gz

- **Partial backup**: Uses the selected filenames joined by underscores plus a timestamp.

Example: 
```
file1_txt_file2_txt_2025-05-15_09-00-00.tar.gz
```

## Scheduling Backups with Cron

To automate backups, add a cron job. For example, to run daily at **2:00 AM**:

**1. Open crontab:**

```
crontab -e

```

**2. Add this line:**

```
0 2 * * * /full/path/to/file_backup_system.sh -s /Users/yourname/Documents >> /Users/yourname/backup.log 2>&1

```

Remember to replace /full/path/to with the actual script location.

---

## Output


**Compressed backup (default):**

```
~/backups/backup_2025-05-15_14-22-00.tar.gz

```

**Uncompressed backup:**

```
~/backups/backup_2025-05-15_14-22-00/

```

---

## Notes

- The source directory must be provided for both full and partial backups.
- If the destination directory is not provided, it defaults to ~/backups.
- Partial backups copy only existing files/folders; warnings are shown for missing ones.
- Temporary files for partial backups are cleaned automatically.
- Backups are compressed by default but compression can be disabled.

