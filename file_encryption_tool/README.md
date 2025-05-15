
# File Encryption Tool

A simple and beginner-friendly Bash script to encrypt and decrypt files using password-based AES-256-CBC encryption with OpenSSL.

---

## Features

- Encrypt files securely using AES-256-CBC encryption algorithm.
- Decrypt previously encrypted files.
- Password input is hidden for security.
- Uses PBKDF2 key derivation for improved security.
- Outputs encrypted files with `.enc` extension.
- Automatically derives decrypted output filename.
- Simple usage and minimal dependencies.

---

## Requirements

- **Linux, macOS, or any Unix-like OS**
- Bash shell
- OpenSSL installed (`openssl` command available)

You can check if OpenSSL is installed by running:

```bash
openssl version
```

If not installed, you can install it via your package manager, e.g.:

- **On Debian/Ubuntu:**
```
sudo apt-get install openssl

```

- **On macOS (with Homebrew):**
```
brew install openssl

```
---

## Usage

- *1. Make the script executable*
```
chmod +x file_encryption_tool.sh

```
- *Run the script with either -e to encrypt or -d to decrypt, followed by the filename:*

```
# To encrypt a file
./encrypt_decrypt.sh -e path/to/yourfile.txt

# To decrypt a file
./encrypt_decrypt.sh -d path/to/yourfile.txt.enc

```
- You will be prompted to enter a password securely (input will be hidden).

- The script will create an encrypted file with .enc appended or a decrypted file removing .enc (or adding .dec if the extension isn't .enc).

---

## Examples

**Encrypting a file:**

```
./encrypt_decrypt.sh -e secrets.txt
Enter password: [hidden]
File encrypted as secrets.txt.enc

```

**Encrypting a file:**

```
./encrypt_decrypt.sh -e secrets.txt
Enter password: [hidden]
File encrypted as secrets.txt.enc

```

If the encrypted file does not end with *.enc*, the decrypted output will have *.dec* appended:

```
./encrypt_decrypt.sh -d encryptedfile
Enter password: [hidden]
File decrypted as encryptedfile.dec

```

---

## How It Works

- The script uses the OpenSSL command-line tool with the AES-256-CBC cipher.
- Password-based encryption uses PBKDF2 to derive a strong encryption key from your password.
- Salt is used in encryption to protect against rainbow table attacks.
- Password input is hidden using read -s to avoid shoulder surfing.
- The script performs basic error checking (file existence, correct parameters).

---

## Security Notes

- Choose a strong password for encryption.
- If you forget the password, the encrypted data cannot be recovered.
- The script does not store passwords anywhere.
- Keep your encrypted files safe and backed up.
- OpenSSL must be kept up to date to avoid known vulnerabilities.

---

## Limitations

- This script is designed for learning purposes.
- Not intended for encrypting extremely large files or production use.
- Does not implement password confirmation or multiple encryption algorithms.
- No GUI interface — command line only.

