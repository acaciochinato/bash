#!/bin/bash
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# Title: Move payments receipts for archival
#
# Date: 07/09/2020
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

ARRAY=("bill_1" "bill_2" "bill_3")                    # Array of bills. Put here the name of the bill that you want to add to the script.
DFT_DATE="$(date +%m.%B)"                             # Set the date format name to rename the files.
YEAR="$(date +%Y)"                                    # Default year format
SRC_FOLDER="/home/Downloads/receipts"                 # Set the path where the files are stored
DEST_FOLDER="/path/to/move/receipts/"                 # Set the path location to move the files  
FILE_EXT=("pdf" "png" "jpeg")                         # Set the files extensions supported 
FLAG=0                                                # Flag to control if the script needs to be executed
REGEX=":[[:space:]]([[:upper:]]+)"                    # Regexp to capture the receipt file type from the output of the 'file' command

log() {
    logger -st "move-receipts" "$*"
}

# Test if the destination folder is valid
if [[ ! -e "$DEST_FOLDER" ]]; then      
    log "Destination folder $DEST_FOLDER is not accessible."
    exit 1
fi

for BILL in "${ARRAY[@]}"; do # Iterate through the items and do all the necessary tasks
    if [[ ! -d "$SRC_FOLDER/$BILL" ]] || [[ ! -d "$DEST_FOLDER/$BILL" ]]; then # Check if both source and destination folders are exists.
	      log "Directory for $BILL not found, creating..."
	      [[ ! -d "$SRC_FOLDER/$BILL" ]] && mkdir "$SRC_FOLDER/$BILL" && log "Created source directory at $SRC_FOLDER/$BILL" 
	      [[ ! -d "$DEST_FOLDER/$BILL" ]] && mkdir "$DEST_FOLDER/$BILL" && log "Created $BILL destination directory at $DEST_FOLDER/$BILL"
    fi

    if [[ $(find "$SRC_FOLDER/$BILL" -maxdepth 1 | wc -l) -gt 1 ]]; then # Check if there's more than one item in the folder and go for the next bill
        log "[x] There's more than ONE file in $BILL directory. Please, make sure that only the current month receipt's is in the destination folder."
        continue
    fi
   
   FILE_PATH=$(ls "$SRC_FOLDER/$BILL/*" 2> /dev/null) # Get the path of the bill file to move
   FILE_TYPE="$(file "$FILE_PATH")" 
 
   if [[ "$FILE_TYPE" =~ $REGEX ]]; then # Capture the file extension
     FILE_TYPE="$(echo "${BASH_REMATCH[1]}" | tr '[:upper:]' '[:lower:]')"
   fi

   for EXT in "${FILE_EXT[@]}"; do # Iterate to make the moves
      if [[ $FILE_TYPE == "$EXT" ]]; then
          [[ ! -d "$DEST_FOLDER/$BILL/$YEAR" ]] && echo "Creating year $YEAR directory for $BILL" && mkdir "$DEST_FOLDER/$BILL/$YEAR"
          mv "$FILE_PATH" "$DEST_FOLDER/$BILL/$YEAR/$DFT_DATE.$FILE_TYPE"
          log "File $BILL was renamed and moved."
          FLAG=1
          break
      fi
    done  
done
    if [[ $FLAG == 0 ]]; then
      log "There are no Files to archive."
      exit 0
    fi