# File Management Projects (Lab)

## Automatic File Sorter

A simple Python script that automatically organizes files in a folder by their types (e.g., Documents, Images, Videos). This is a great utility to keep your directories clean and structured.

---

### Features

- Automatically detects file types based on extensions.
- Sorts files into categorized subfolders:
  - Documents
  - Images
  - Videos
  - Music
  - Archives
  - Scripts
  - Others
- Skips folders and only sorts files.
- Works in the current working directory.

---

### Skills

- File handling
- string manipulation
- if-else statements
- creating of folders

---

### How It Works

1. The script defines a dictionary with common file types and their extensions.
2. It scans the current directory.
3. It checks the extension of each file.
4. It moves each file to a matching subfolder.
5. If a file doesn’t match any known type, it goes into an `Others` folder.

---

### 📦 Example

Before running the script:
```
/myfolder
├── image1.jpg
├── doc1.pdf
├── video1.mp4
├── script.py
├── random.xyz

```

After running the script:
```
/myfolder
├── Documents
│ └── doc1.pdf
├── Images
│ └── image1.jpg
├── Videos
│ └── video1.mp4
├── Scripts
│ └── script.py
├── Others
└── random.xyz

---

### How To Use

*1. Make the script executable*
```
chmod +x file_sorter.sh 

```
*2. Run the Script*
```
./file_sorter.sh /path/to/your/folder

```

---

### Supported File Types

| **Category** | **Extensions**                          |
|--------------|------------------------------------------|
| Documents    | .pdf, .docx, .txt, .xlsx                |
| Images       | .jpg, .jpeg, .png, .gif                 |
| Videos       | .mp4, .avi, .mov, .mkv                  |
| Music        | .mp3, .wav, .aac                        |
| Archives     | .zip, .rar, .tar, .gz                   |
| Scripts      | .py, .js, .sh, .bat                     |
| Others       | Any file not matching the above         |





