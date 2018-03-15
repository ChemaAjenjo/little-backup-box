#!/usr/bin/env bash

# IMPORTANT:
# Run the install-little-backup-box.sh script first
# to install the required packages and configure the system.

# Specify devices and their mount points
# and other settings
STORAGE_DEV="sda1" # Name of the storage device
STORAGE_MOUNT_POINT="/media/storage" # Mount point of the storage device
CARD_DEV="sdb1" # Name of the storage card
CARD_MOUNT_POINT="/media/card" # Mount point of the storage card
SHUTD="15" # Minutes to wait before shutdown due to inactivity
REMOTE_PATH="remote:photo_backup" # rclone repository
TOKEN="<token>" # Token of your telegram bot
CHATID="<chat_id>" # Your user chat_id in Telegram
LOG="/home/pi/little-backup-box.log" # Log file. IMPORTANT: equals than in crontab

# If there is a wpa_supplicant.conf file in the root of the storage device
# Rename the original config file,
# move wpa_supplicant.conf from the card to /etc/wpa_supplicant/
# Reboot to enable networking
if [ -f "$STORAGE_MOUNT_POINT/wpa_supplicant.conf" ]; then
    sudo sh -c "echo 100 > /sys/class/leds/led0/delay_on"
    mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.bak
    mv "$STORAGE_MOUNT_POINT/wpa_supplicant.conf" /etc/wpa_supplicant/wpa_supplicant.conf
    reboot
fi

# Check if internet connection exist
wget -q --spider http://google.com
[ $? -eq 0 ] && { NETWORK=1; } || { NETWORK=0; }

# Set the ACT LED to heartbeat
sudo sh -c "echo heartbeat > /sys/class/leds/led0/trigger"

# Shutdown after a specified period of time (in minutes) if no device is connected.
sudo shutdown -h $SHUTD "Shutdown is activated. To cancel: sudo shutdown -c"

# Wait for a USB storage device (e.g., a USB flash drive)
STORAGE=$(ls /dev/* | grep $STORAGE_DEV | cut -d"/" -f3)
while [ -z ${STORAGE} ]
  do
  sleep 1
  STORAGE=$(ls /dev/* | grep $STORAGE_DEV | cut -d"/" -f3)
done

# When the USB storage device is detected, mount it
mount /dev/$STORAGE_DEV $STORAGE_MOUNT_POINT

# Cancel shutdown
sudo shutdown -c

# Set the ACT LED to blink at 1000ms to indicate that the storage device has been mounted
sudo sh -c "echo timer > /sys/class/leds/led0/trigger"
sudo sh -c "echo 1000 > /sys/class/leds/led0/delay_on"

# Wait for a card reader or a camera
CARD_READER=$(ls /dev/* | grep $CARD_DEV | cut -d"/" -f3)
until [ ! -z $CARD_READER ]
  do
  sleep 1
  CARD_READER=$(ls /dev/sd* | grep $CARD_DEV | cut -d"/" -f3)
done

# If the card reader is detected, mount it and obtain its UUID
if [ ! -z $CARD_READER ]; then
  mount /dev/$CARD_DEV $CARD_MOUNT_POINT
  # # Set the ACT LED to blink at 500ms to indicate that the card has been mounted
  sudo sh -c "echo 500 > /sys/class/leds/led0/delay_on"

  # Create  a .id random identifier file if doesn't exist
  cd $CARD_MOUNT_POINT
  if [ ! -f *.id ]; then
    touch $(date -d "today" +"%Y-%m-%d_%H%M").id
  fi
  ID_FILE=$(ls *.id)
  ID="${ID_FILE%.*}"
  cd

  # Set the backup path
  BACKUP_PATH=$STORAGE_MOUNT_POINT/"$ID"

  # Log the output of the lsblk command for troubleshooting
  sudo lsblk > lsblk.log
  
  # Perform backup using rsync
  rsync -av --exclude "*.id" --include "*.NEF" --include "*.JPG" --include "*.MOV" --include */**""$CARD_MOUNT_POINT/ $BACKUP_PATH

  # Geocorrelate photos if a .gpx file exists
  cd $STORAGE_MOUNT_POINT
  if [ -f *.gpx ]; then
    GPX="$(ls *.gpx)"
    exiftool -overwrite_original -r -ext jpg -geotag "$GPX" -geosync=120 .
  fi
  
  cd $CARD_MOUNT_POINT
  rm $ID_FILE
  cd
  sudo umount -l $CARD_MOUNT_POINT

  sleep 10
  
  [ $NETWORK -eq 1 ] && { curl -s -i -F chat_id="$CHATID" -F text="Ya puedes extraer la tarjeta" -X GET https://api.telegram.org/bot$TOKEN/sendMessage; }

  # Turn off the ACT LED to indicate that the backup is completed
  sudo sh -c "echo 0 > /sys/class/leds/led0/brightness"
fi

# Upload files from $BACKUP_PATH to remote server only with internet.
if [ $NETWORK -eq 1 ]; then
  curl -s -i -F chat_id="$CHATID" -F text="Iniciando la carga en remoto" -X GET https://api.telegram.org/bot$TOKEN/sendMessage
  rclone -v --no-check-certificate copy $BACKUP_PATH $REMOTE_PATH
  curl -s -i -F chat_id="$CHATID" -F text="Finalizada la carga en remoto" -X GET https://api.telegram.org/bot$TOKEN/sendMessage
  curl -s -F chat_id="$CHATID" -F document=@"$LOG" https://api.telegram.org/bot$TOKEN/sendDocument;
fi

# Shutdown
sync
shutdown -h now
