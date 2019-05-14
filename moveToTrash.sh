#!/bin/bash

fileToTrash="$1"

# From https://stackoverflow.com/a/246128
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
BACKUP_DIR="$DIR/backup"
STEAM_PRGM_FOLDER="$HOME/.local/share/Steam"

BASE_FOLDER_LENGTH=${#STEAM_PRGM_FOLDER}

# The file to trash, from the STEAM_PROGRAM_FOLDER
FILE_RELATIVE_TO_STEAM=${fileToTrash:$BASE_FOLDER_LENGTH + 1}

BACKUP_FILE_PATH="$BACKUP_DIR/$FILE_RELATIVE_TO_STEAM"

if [ "${fileToTrash:0:1}" != "/" ]; then
  echo "Unable to trash $fileToTrash"
  echo "Filename must be absolute."
  
  exit 0
fi

if [[ $fileToTrash == *".old"* ]]; then
  echo -e "\e[0;35mIgnoring\033[0m $fileToTrash"
  
  exit 0
fi

# Make a backup of the fileToTrash
mkdir -p dirname "$(dirname "$BACKUP_FILE_PATH")"
cp -f -p -r "$fileToTrash" "$BACKUP_FILE_PATH"

if [ -f "$fileToTrash" ] || [ -d "$fileToTrash" ]; then
  if ! gio trash "$fileToTrash"; then
    echo -e "\e[0;31mUnable to trash $fileToTrash\033[0m"
  else
    echo -e "\e[32mMoved to trash\033[0m $fileToTrash"
  fi
else
  echo -e "\e[0;33mFile does not exist\033[0m $fileToTrash"
fi

unset fileToTrash
