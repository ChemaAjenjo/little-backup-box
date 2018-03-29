#!/usr/bin/env bash

set -x

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# IMPORTANT:
# Run the install-little-backup-box.sh script first
# to install the required packages and configure the system.

# Specify devices and their mount points
# and other settings
HOME_DIR="/home/pi/BACKUP" # Home directory path
MICROSD_DEV="sdb1" # Name of the storage card
MICROSD_MOUNT_POINT="/media/microsd" # Mount point of the storage card
CARD_DEV="sda1" # Name of the storage card
CARD_MOUNT_POINT="/media/card" # Mount point of the storage card
SHUTD="5" # Minutes to wait before shutdown due to inactivity

# Set the ACT LED to heartbeat
sudo sh -c "echo heartbeat > /sys/class/leds/led0/trigger"

# Shutdown after a specified period of time (in minutes) if no device is connected.
sudo shutdown -h $SHUTD "Shutdown is activated. To cancel: sudo shutdown -c"

# Set the ACT LED to blink at 1000ms to indicate that the storage device has been mounted
sudo sh -c "echo timer > /sys/class/leds/led0/trigger"
sudo sh -c "echo 1000 > /sys/class/leds/led0/delay_on"

# Wait for a card reader or a camera, while led orange blink
CARD_READER=$(ls /dev/* | grep $CARD_DEV | cut -d"/" -f3)
MICROSD_READER=$(ls /dev/* | grep $MICROSD_DEV | cut -d"/" -f3)
until [ ! -z $CARD_READER ] || [ ! -z $MICROSD_READER ]
  do
  sleep 1
  CARD_READER=$(ls /dev/sd* | grep $CARD_DEV | cut -d"/" -f3)
  MICROSD_READER=$(ls /dev/* | grep $MICROSD_DEV | cut -d"/" -f3)
done

# Cancel shutdown
sudo shutdown -c

# Create internal backup dir if not exist
[ ! -z "$HOME_DIR" ] && { mkdir $HOME_DIR; }

# If the card reader is detected, mount it and obtain its UUID
if [ ! -z $CARD_READER ]; then
  mount /dev/$CARD_DEV $CARD_MOUNT_POINT
  # # Set the ACT LED to blink at 500ms to indicate that the card has been mounted
  sudo sh -c "echo 500 > /sys/class/leds/led0/delay_on"

  # Create  a .id random identifier file if doesn't exist
  cd $CARD_MOUNT_POINT
  if [ ! -f *.id ]; then
    touch $(date -d "today" +"%Y%m%d%H%M").id
  fi
  ID_FILE=$(ls *.id)
  ID="${ID_FILE%.*}"
  cd

  [ ! -z "$HOME_DIR/SDCARD" ] && { mkdir $HOME_DIR/SDCARD; }
  
  # Set the backup path
  BACKUP_PATH=$HOME_DIR/SDCARD/"$ID"
  
  # Perform backup using rsync
  rsync -av --exclude "*.id" $CARD_MOUNT_POINT/ $BACKUP_PATH

  # Turn off the ACT LED to indicate that the backup is completed
  sudo sh -c "echo 0 > /sys/class/leds/led0/brightness"
fi

# If the microcard reader is detected
if [ ! -z $MICROSD_READER ]; then
  mount /dev/$MICROSD_DEV $MICROSD_MOUNT_POINT
  # # Set the ACT LED to blink at 500ms to indicate that the card has been mounted
  sudo sh -c "echo 500 > /sys/class/leds/led0/delay_on"

  # Create  a .id random identifier file if doesn't exist
  cd $MICROSD_MOUNT_POINT
  if [ ! -f *.id ]; then
    touch $(date -d "today" +"%Y%m%d%H%M").id
  fi
  ID_FILE=$(ls *.id)
  ID="${ID_FILE%.*}"
  cd

  [ ! -z "$HOME_DIR/MICROSD" ] && { mkdir $HOME_DIR/MICROSD; }
  
  # Set the backup path
  BACKUP_PATH=$HOME_DIR/MICROSD/"$ID"
  
  # Perform backup using rsync
  rsync -av --exclude "*.id" $MICROSD_MOUNT_POINT/ $BACKUP_PATH

  # Turn off the ACT LED to indicate that the backup is completed
  sudo sh -c "echo 0 > /sys/class/leds/led0/brightness"
fi

# Shutdown
sync
shutdown -h 1