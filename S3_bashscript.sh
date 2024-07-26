#!/bin/bash

# Cofiguration
SOURCE_DIR="/mnt/c/Users/HP 250/desktop/test"
BACKUP_DIR="/mnt/c/Users/HP 250/desktop"
DATE=$(date +%Y-%m-%d)
BACKUP_FILE="$BACKUP_DIR/backup$DATE.tar.gz"
DEST_BUCKET="s3://project-bucket-2021"
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
   # Upload the backup to S3
   aws s3 cp "$BACKUP_FILE" "$DEST_BUCKET"
   if [ $? -eq 0 ]; then
      # If successful, notify success
      send_email "Backup Successful" "Sucessfully uploaded the backup"
   else
      # If upload failed, notify failure
      send_email "Backup Failed" "The backup process failed during upload. Please check the server."
  fi
else
   # If backup creation failed, notify failure
   send_email "Backup Failed" "The backup process failed during upload. Please check the server."
fi



