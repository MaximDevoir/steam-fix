#!/bin/bash

# From https://stackoverflow.com/a/246128
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"


GIST_URL="https://github.com/MaximDevoir/steam-fix"
ISSUES_URL="https://github.com/MaximDevoir/steam-fix/issues"

# Follows semi-semver spec. Uses ABBCC format where A is major version, BB is
# minor, and CC is patch. BB and CC must be exactly 2 digits long. Otherwise,
# the script will do incorrect calculations for checking if software is
# up-to-date.
CURRENT_VERSION=$(head -n 1 "$DIR"/version)

SCRIPT_VERSION_URL="https://raw.githubusercontent.com/MaximDevoir/steam-fix/master/version"

echo "Checking if software is up-to-date"
echo ""

REMOTE_LATEST_VERSION=$(wget $SCRIPT_VERSION_URL -q -O -)

re='^[0-9]+$'
if ! [[ $REMOTE_LATEST_VERSION =~ $re ]] ; then
  echo "Error: Couldn't fetch the latest version."
  echo "Try checking if you are connected to the internet and rerun the script"
  echo "Or, verify that you can load $SCRIPT_VERSION_URL"
  echo ""
  echo "Would you like to ignore checking the latest version"
  select yn in "Yes, ignore checking if I have the latest version" "No, quit now"; do
      case $yn in
          Yes* ) first_message; break;;
          No* ) echo "You selected no; exiting now" && exit;;
      esac
  done
fi


if (( REMOTE_LATEST_VERSION > CURRENT_VERSION )); then
  echo "Software is out-of-date."
  echo "Your version: $CURRENT_VERSION"
  echo "Latest version: $REMOTE_LATEST_VERSION"

  echo "Please update your scripts at $GIST_URL"

  echo ""

  echo "Would you like to ignore updating to the current version (not recommended)"
  select yn in "Yes, ignore updating" "No, I will update the scripts"; do
      case $yn in
          Yes* ) first_message; break;;
          No* ) echo "You selected no; visit $GIST_URL to update your scripts; exiting now" && exit;;
      esac
  done
else
  echo "Software up to date"
  echo "Your version: $CURRENT_VERSION"
  echo "Latest version: $REMOTE_LATEST_VERSION"
fi

echo ""

first_message () {
  log_about
  echo "I have read above and am ready to begin?"

  select yn in "Yes" "No"; do
      case $yn in
          Yes ) second_message; break;;
          No ) echo 'You selected NO; exiting now' && exit;;
      esac
  done
}

second_message () {
  echo ""
  echo ""
  echo "Are you sure?"
  select yn in "Yes" "No"; do
      case $yn in
          Yes ) fix_steam; break;;
          No ) echo 'You selected NO; exiting now' && exit;;
      esac
  done
}

log_about () {
  echo ""
  echo "Steam Fixer for Linux Systems"
  echo "- Maxim Devoir 2019"
  echo "Available at $GIST_URL"
  echo "Report any issues to $ISSUES_URL"
  echo ""
  echo "This program removes libstdc++* and libgcc* libraries from"
  echo "$HOME/.local/share/Steam/"
  echo ""
}

fix_steam () {
  echo ""
  echo "Fixing steam"
  echo ""
  COMMAND_TO_RUN="/bin/bash -e -c $DIR/fixSteam.sh"

  echo "Executing $COMMAND_TO_RUN"

  $COMMAND_TO_RUN

  fixed_steam
}

# The messsages to run after `fix_steam`
fixed_steam () {
  echo "------------"
  echo "------------"
  echo "------------"
  echo -e "\e[0;32mPlease READ:\033[0m"
  echo "A backup of the removed files has been made at:"
  echo "$DIR/backup"
  echo ""

  echo "If you encounter any problems with steam or any games, you can try restoring the files by:"

  echo " - Restoring the deleted files from Trash (recommended)"
  echo " - Copying the backup files into $HOME/.local/share/Steam"
  echo " - Reinstalling Steam (which restores Steam's libstdc and libgcc files)"
  echo " - Verifying the integrity of a game (which restores libgcc and libstdc files)"

  echo ""
  echo "Report any issues to $ISSUES_URL"

  echo ""
  echo ""
  echo "If this software has been useful, give the repo a star"
  echo "$GIST_URL"
}


make_backup_dir () {
  mkdir -p "$DIR/backup"
}

make_backup_dir

first_message
