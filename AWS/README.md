# aws-glacier.sh

The script is an automation to backup files from your filesystem to a valid AWS S3 bucket, making sure that the source and destination folders are always in sync, so deleted files in your local filesystem will also be deleted in the remote S3 bucket.

The script is coded to execute the backup only once a month, in the first 7 days. This was a personal decision due to my personal needs. If the script is triggered in any other day beyond the 7th, a message is sent via e-mail.

The output in logged to a given file configured via variables. The file then gets compressed and send to a defined e-mail address.

# Requirements

- aws-cli 2.0