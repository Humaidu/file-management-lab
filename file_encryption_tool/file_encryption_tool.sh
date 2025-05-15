#!/bin/bash

# ================================================================
# File Encryption Tool
# Description:
# Creates a script to encrypt and decrypt files using a password.
# Implements a safe encryption method and handle key management securely.
# ================================================================

# ================================================================
# Simple file encryption/decryption script using openssl AES-256-CBC

# Usage:
#   ./script.sh -e filename   # to encrypt a file
#   ./script.sh -d filename   # to decrypt a file
#
# Encryption output: filename.enc
# Decryption output: filename (if input ends with .enc) or filename.dec (otherwise)
#
# Password is requested securely (not shown on screen)
# Uses PBKDF2 for secure key derivation from password
# ================================================================


# Function to display correct usage and exit
show_usage() {
    echo "Usage:"
    echo "  $0 -e filename   # Encrypt file"
    echo "  $0 -d filename   # Decrypt file"
    exit 1
}

# Check if exactly two arguments are provided
if [ $# -ne 2 ]; then
    show_usage  # Show usage instructions if arguments are missing or too many
fi

mode=$1    # First argument: -e (encrypt) or -d (decrypt)
file=$2    # Second argument: filename to encrypt/decrypt

# Check if the specified file exists and is a regular file
if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found."
    exit 1
fi

# Prompt the user to enter a password securely
# -s option hides the input for privacy
read -s -p "Enter password: " password
echo 

if [ "$mode" = "-e" ]; then
    # Encrypt the file using openssl AES-256-CBC with a salt and PBKDF2 key derivation
    # -pass pass:"$password" provides the password securely
    # Output file will be the original filename plus ".enc"
    openssl enc -aes-256-cbc -salt -pbkdf2 -pass pass:"$password" -in "$file" -out "$file.enc"

    # Check if the encryption command was successful
    if [ $? -eq 0 ]; then
        echo "File encrypted as $file.enc"
    else
        echo "Encryption failed."
        exit 1
    fi

elif [ "$mode" = "-d" ]; then
    # Determine output filename after decryption
    # If input file ends with ".enc", remove that suffix for output filename
    # Otherwise, add ".dec" suffix to the output filename
    if [[ "$file" == *.enc ]]; then
        outfile="${file%.enc}"
    else
        outfile="$file.dec"
    fi

    # Decrypt the file using openssl AES-256-CBC with PBKDF2 key derivation
    openssl enc -d -aes-256-cbc -pbkdf2 -pass pass:"$password" -in "$file" -out "$outfile"

    # Check if the decryption command was successful
    if [ $? -eq 0 ]; then
        echo "File decrypted as $outfile"
    else
        echo "Decryption failed. Wrong password or corrupted file?"
        exit 1
    fi

else
    # If the mode is neither -e nor -d, show usage instructions
    show_usage
fi

