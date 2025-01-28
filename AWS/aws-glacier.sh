#!/bin/bash
LOG_PATH=/var/log/aws
LOG_FILE="s3-glacier_$(date +%F).log"
COMP_LOG_FILE="$LOG_PATH/$LOG_FILE.tar.xz"
AWS_BIN=/usr/local/bin/aws
RC=0
SCRIPT_NAME=$(basename "$0")
EMAIL_ADDR="your-email@mail.com"
S3_BUCKET="s3://bucket-name/folder-name"
S3_STORAGE_CLASS="DEEP_ARCHIVE"
LOCAL_FOLDER="/path/to/your/local/folder"
exec 1> "$LOG_PATH/$LOG_FILE"
exec 2>&1

Log () {
        logger -st "$SCRIPT_NAME" "$*"
}

Compression (){
        
        tar -Jcf "$COMP_LOG_FILE" -C "$LOG_PATH" -P "$LOG_FILE"
}

Send_mail () {
        /usr/bin/mail -s "S3 $S3_STORAGE_CLASS" -A "$COMP_LOG_FILE" "$EMAIL_ADDR"
}

if [[ $(date +%d) -le 8 ]]; then
        Log "Initiating file uploads to AWS $S3_STORAGE_CLASS"
        $AWS_BIN s3 sync --delete --storage-class "$S3_STORAGE_CLASS" "$LOCAL_FOLDER" "$S3_BUCKET"
        RC=$?
        
        if [[ $RC -eq 0 ]]; then
          Log "Finished uploading files" && Compression
          echo "Uploaded files to AWS , check the log file $LOG_FILE for more information." | Send_mail
        else
          Log "Return Code: $RC - Error uploading files to AWS" && Compression
          echo "ERROR - Check the log file $LOG_FILE for more information." | Send_mail
          exit 1
        fi
else
        Log "Not the first 8 days of the month, nothing to do" && Compression
        echo "Not the first 8 days of the month. No files were uploaded." | Send_mail
        exit 0
fi