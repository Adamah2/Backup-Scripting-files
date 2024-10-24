# Backup-Scripting-files
This project automates the process of backing up files from a local machine to AWS S3 and EC2. It's designed to offer a reliable and scalable solution for securing important data using cloud storage services.

Features

Backup to S3: Automatically upload selected files from your local machine to an S3 bucket.

Backup to EC2: Sync files to an EC2 instance for additional redundancy or processing.

Automation: Simple script for running backups on a schedule using CRON (Linux).

Technologies Used

AWS S3: Cloud storage for file backups.

AWS EC2: Virtual server for storing backups or performing processing tasks.

AWS CLI: Command-line interface for interacting with AWS services.

Bash / PowerShell: For scripting the backup automation.

Prerequisites

AWS account with S3 and EC2 setup.

AWS CLI configured on your machine.

S3 bucket and EC2 instance properly provisioned.
