#!/bin/bash

# Cofiguration
SOURCE_DIR="/mnt/c/Users/HP 250/desktop/test"
BACKUP_DIR="/mnt/c/Users/HP 250/desktop"
DATE=$(date +%Y-%m-%d)
BACKUP_FILE="$BACKUP_DIR/backup$DATE.tar.gz"
KEYPEM_DIR="/home/adamah/script.sh.pem"
BACKUP_SERVER_NAME="ubuntu"
BACKUP_SERVER_IP="13.39.24.88"
BACKUP_SERVER_DIR="/home/ubuntu/backup"
ADMIN_EMAIL="emmanueladamah2@gmail.com"

# Functions to send email notification using mutt
send_email() {
    local subject=$1
    local message=$2
    echo "$message" | mutt -s "$subject" "$ADMIN_EMAIL"
} 

# Notify that the backup process has started
send_email "Backup Started" "The backup process has started"

# Create the backup
tar -czvf "$BACKUP_FILE" "$SOURCE_DIR"
if [ $? -eq 0 ]; then
# If upload was successful notify success	
send_email "Creating backup" "Sucessfully created a zipped file for the backup"
else
# If upload failed, notify failure
send_email "Backup Failed" "The backup process failed during upload. Please check the server."
fi

sleep 10s
# Copying backup files to remote server
scp -i "$KEYPEM_DIR" "$BACKUP_FILE" "$BACKUP_SERVER_NAME"@"$BACKUP_SERVER_IP":"$BACKUP_SERVER_DIR"

# Checking if the scp command run sucessfully
if [ $? -eq 0 ]; then
# If command run sucessful notify sucess
send_email "Sending backup" "Backup was sent successfully"
else
# If command fails notify Admin
send_email "Sending backup" "Backup failed"
fi

   


