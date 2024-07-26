#!/bin/bash

# Configuration
HOME="/home/adamah"
SOURCE_DIR="$HOME"
ARCHIVE_DIR="$HOME/archives"
ADMIN_EMAIL="emmanueladamah2@gmail.com"
KEYPEM_DIR="/home/adamah/script.sh.pem"
BACKUP_SERVER_NAME="ubuntu"
BACKUP_SERVER_IP="13.38.76.241"
BACKUP_SERVER_DIR="/home/ubuntu/archives"

# Functions to send email notification using mutt
send_email() {
    local subject=$1
    local message=$2
    echo "$message" | mutt -s "$subject" "$ADMIN_EMAIL"
}

# Notify that the file management process has started
send_email "File Management Started" "The file management process has started"

# Check if the archive directory exists, create it if not
if [ ! -d "$ARCHIVE_DIR" ]; then
    echo "Archive directory does not exist. Creating now..."
    mkdir -p "$ARCHIVE_DIR"
    echo "Archive directory created."
fi

# Find and move files not accessed in the last 90 days, excluding hidden files and .sh files
echo "Searching for files not accessed in the last 90 days..."
find "$SOURCE_DIR" -type f ! -name ".*" ! -name "*.sh" -atime +90 -exec mv {} "$ARCHIVE_DIR" \;

# Check if the find and move command was successful
if [ $? -eq 0 ]; then
    # If successful, notify success
    send_email "File Management Success" "Files not accessed in the last 90 days have been successfully moved to $ARCHIVE_DIR."
else
    # If failed, notify failure
    send_email "File Management Failed" "The file management process failed. Please check the server."      
fi

# Copying archive files to the EC2 instance
echo "Copying archive files to the EC2 instance..."
scp -i "$KEYPEM_DIR" -r "$ARCHIVE_DIR" "$BACKUP_SERVER_NAME"@"$BACKUP_SERVER_IP":"$BACKUP_SERVER_DIR"

# Checking if the scp command run successfully
if [ $? -eq 0 ]; then
    # If command runs successfully, notify success
    send_email "File Management and EC2 Upload Success" "Files have been successfully moved to $ARCHIVE_DIR and uploaded to the EC2 instance at $BACKUP_SERVER_DIR."
else
    # If command fails, notify failure
    send_email "EC2 Upload Failed" "The file management was successful, but the upload to the EC2 instance failed. Please check the connection and settings."
fi                                                                                                