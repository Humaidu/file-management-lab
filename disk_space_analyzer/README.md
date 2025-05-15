# Disk Space Analyzer

A simple, beginner-friendly **Bash script** to analyze disk usage in a directory and display a tree-like structure of files and folders sorted by size. The tool helps identify which files or folders use the most disk space, with optional sorting and filtering.

---

## Features

- Recursively lists disk usage of files and directories
- Shows sizes in human-readable megabytes (MB)
- Displays output in a tree-like indented format reflecting directory depth
- Optional sorting by largest or smallest size
- Filter results by minimum file/folder size in MB
- Handles directories with only files or nested folders
- Platform compatible (macOS, Linux)

---

## Requirements

- Bash shell
- `du`, `sort`, `awk`, and standard Unix utilities (available by default on macOS and Linux)

---

## Usage

*1. Make the script executable*
```
chmod +x disk_space_analyzer.sh

```
*2. Run the Script*
```
./disk_space_analyzer.sh [directory] [sort_option] [min_size_MB]

```

---

## Arguments

| Argument     | Description                                | Default          |
|--------------|--------------------------------------------|------------------|
| directory    | Target directory to analyze                | Current dir (.)  |
| sort_option  | Sort by "largest", "smallest", or "none" (no sorting) | none             |
| min_size_MB  | Minimum size in MB to include in the output | 0 (show all)     |

---

##  Examples

**1. Analyze current directory without sorting or filtering:**

```
./disk_space_analyzer.sh

```

**2. Analyze a folder called test_folder, sorted by largest files first:**

```
./disk_space_analyzer.sh test_folder largest

```

**3. Analyze test_folder, show files/folders larger than 5 MB, sorted smallest to largest:**

```
./disk_space_analyzer.sh test_folder smallest 5

```

---

## Output

**The script outputs each file/folder with:**

- Size in megabytes (rounded to 1 decimal place)
- Indentation reflecting folder depth
- Relative path from the target directory

```
- 12.3M  logs
  - 5.0M  error.log
  - 3.2M  access.log
- 8.5M  images
  - 2.3M  logo.png
  - 1.1M  banner.jpg
- 0.1M  README.md

```
---

## How It Works

- Uses du -ak to get sizes of all files and folders in kilobytes.
- Filters entries smaller than the specified minimum size.
- Sorts entries numerically, descending (largest) or ascending (smallest), or leaves unsorted.
- Formats output with indentation showing directory depth and sizes converted to MB.

---

## Notes
- On macOS, the -a flag in du is required to include individual files, as du by default reports only directory sizes.
- Empty directories or folders with no files matching the minimum size will produce no output.
- The script assumes the passed directory exists and is accessible.
- Output size formatting is approximate (1 decimal place).

---

## Troubleshooting

**No output?**
Make sure the directory exists and contains files or folders larger than the minimum size filter.

**Permission denied errors?**
Run the script with appropriate permissions or on directories where you have read access.

**Compatibility issues?**
This script is tested on macOS and Linux. Some options in du may differ on other systems.