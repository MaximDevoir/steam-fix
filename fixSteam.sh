#!/bin/bash

# fixSteam.sh: Removes libstdc++* and libgcc* libraries from
# $HOME/.local/share/Steam/

# Relates to:
#   - https://steamcommunity.com/app/222880/discussions/1/1480982971174434853/
#   - https://www.reddit.com/r/linux_gaming/comments/7axkhi/weekly_techsupport_thread_for_november_05_2017/dpe41va
#   -  https://steamcommunity.com/app/221910/discussions/0/517141624283080668
echo "Fixing Steam AMD driver-related issues"
echo "Detecting if Steam is running."

STEAM_BINARY="$(command -v steam)"
# The location of the Steam software
STEAM_PRGM_FOLDER="$HOME/.local/share/Steam"
STEAM_PGRM_COUNT=$(pgrep -cf "$STEAM_PRGM_FOLDER")
STEAM_LOOP_CHECK_COUNT=0
# The amount of times to check if Steam or its processes are still running
STEAM_LOOK_CHECK_LIMIT=5
# The time to sleep between each check on `steam -shutdown`.
STEAM_LOOP_SLEEP_COUNT=3s

if [ "$STEAM_PGRM_COUNT" -gt 0 ]; then
  echo "Discovered Steam running."
  echo "Shutting steam down now."
  eval "$STEAM_BINARY -shutdown" &>/dev/null & disown;
  sleep 1s
fi

while [ "$(pgrep -cf "$HOME/.local/share/Steam")" -ne 0 ]; do
  STEAM_LOOP_CHECK_COUNT=$((STEAM_LOOP_CHECK_COUNT+1))
  echo -n "... "

  if [ $STEAM_LOOP_CHECK_COUNT -ge $STEAM_LOOK_CHECK_LIMIT ]; then
    break
  fi
  
  sleep $STEAM_LOOP_SLEEP_COUNT
done

STEAM_PGRM_COUNT=$(pgrep -cf "$STEAM_PRGM_FOLDER")

echo ""

if [ "$STEAM_PGRM_COUNT" -ne 0 ]; then
  echo "Processes still running" "$(pgrep -f "$HOME/.local/share/Steam" | tr '\n' ' ')"
  echo -e "\e[0;31mIt looks like Steam is still running\033[0m $STEAM_PGRM_COUNT processes."
  echo -e "\e[0;31mWait for it to close and try again.\033[0m"
  echo "If that does not work, you must manually close out of all instances of Steam."
  exit 1
else
  echo "Did not detect any running instances of Steam."
fi

printf "\nMoving libstdc++ libraries to trash.\n"
find "$STEAM_PRGM_FOLDER" -name "*libstdc++*" -exec /bin/bash ./moveToTrash.sh {} \;

printf "\nMoving libgcc libraries to trash.\n"
find "$STEAM_PRGM_FOLDER" -name "*libgcc*" -exec /bin/bash ./moveToTrash.sh {} \;

unset STEAM_LOOK_CHECK_LIMIT
unset STEAM_LOOP_SLEEP_COUNT
unset STEAM_LOOP_CHECK_COUNT
unset STEAM_PRGM_FOLDER
unset STEAM_BINARY
unset STEAM_PROCESSES

printf "\nFinished.\n"
