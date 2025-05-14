# Bulk File Renamer (Bash Script)

A simple and flexible Bash script to rename multiple files in a directory using custom patterns such as prefixes, suffixes, counters, and dates.

---

## Features

- Add custom prefixes or suffixes to filenames
- Append counters with a customizable start number
- Append the current date to filenames
- Safe renaming with built-in checks
- Easy to understand and modify

---

## Requirements

- Bash shell (Linux/macOS/WSL)
- Basic command-line knowledge

---

## Usage

*1. Make the script executable*
```
chmod +x bulk_file_renamer.sh

```
*2. Run the Script*
```
./bulk_file_renamer.sh <directory> [options]

```
---

## Options

| **Option**     | **Description**                                 | **Example**         |
|----------------|-------------------------------------------------|---------------------|
| prefix=VALUE   | Add prefix to each filename                     | prefix=holiday_     |
| suffix=VALUE   | Add suffix to each filename (before extension)  | suffix=_2025        |
| counter        | Add a counter number to each filename           | counter             |
| start=N        | Starting number for counter (default: 1)        | start=100           |
| date           | Add current date (YYYYMMDD) to filename         | date                |

> You can combine options to suit your needs.

---

## 🧪 Examples

### 1. Add a prefix and suffix:

```
./bulk_file_renamer.sh ./photos prefix=trip_ suffix=_paris

```
*Old filenames → New filenames:*
```
IMG001.jpg → trip_IMG001_paris.jpg
IMG002.jpg → trip_IMG002_paris.jpg

```

### 2. Add counter starting from 100:

```
./bulk_file_renamer.sh ./docs prefix=report_ counter start=100

```
*Old filenames → New filenames:*
```
summary.txt → report_summary_100.txt
intro.txt   → report_intro_101.txt

```

### 3. Add current date:

```
./bulk_file_renamer.sh ./logs date

```
*Old filenames → New filenames:*
```
output.log → output_20250514.log

```

### 3. Combine all options:

```
./bulk_file_renamer.sh myfiles prefix=project_ suffix=_v1 counter start=101 date

```
*Old filenames → New filenames:*
```
project_file1 → project_file1_101_20250514_v1.txt
project_file2 → project_file2_102_20250514_v1.txt

```

---

## How It Works

- The script loops through all regular files in the specified directory.
- It constructs a new filename using your options.
- It safely renames each file using mv -i (interactive mode) to prevent overwrites.
- It supports common Bash string operations for extracting file extensions and base names.

---

## Notes

- The script only renames regular files (not folders).
- The original file extension is preserved.
- If a file with the new name already exists, you'll be prompted to confirm overwrite (mv -i behavior).
- It works only on one directory at a time and does not rename files recursively.

---

## Sample Directory Structure

Before running:
```
myfolder/
├── file1.txt
├── file2.txt
└── file3.txt

```

After running:
```
./bulk_file_renamer.sh ./myfolder prefix=new_ counter

```
Output:
```
myfolder/
├── new_file1_1.txt
├── new_file2_2.txt
└── new_file3_3.txt

```

