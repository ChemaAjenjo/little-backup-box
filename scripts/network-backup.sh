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

HOME_DIR="/home/pi/BACKUP/" # Home directory path
LOG="$1"

# Set the ACT LED to heartbeat
sudo sh -c "echo heartbeat > /sys/class/leds/led0/trigger"

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

# Set the ACT LED to blink at 1000ms to indicate that the storage device has been mounted
sudo sh -c "echo timer > /sys/class/leds/led0/trigger"
sudo sh -c "echo 1000 > /sys/class/leds/led0/delay_on"

# Make blink led while transfer files to local backup folder
gpio -g blink 21 &
pid_blink=$!

# Check if internet connection exist
wget -q --spider http://google.com
# Upload files from $BACKUP_PATH to remote server only with internet connection
if [ $? -eq 0 ]; then
  cd $(dirname $0)
  cd ..
  source network.conf
  rclone -v --log-file="$LOG" --no-check-certificate sync $HOME_DIR $REMOTE_PATH
  curl -s -F chat_id="$CHATID" -F document=@"$LOG" https://api.telegram.org/bot$TOKEN/sendDocument > /dev/null
fi
# Turn off the ACT LED to indicate that the backup is completed
sudo sh -c "echo 0 > /sys/class/leds/led0/brightness"

# Stop led blink
sudo kill $pid_blink > /dev/null

# Shutdown
sync
shutdown -h now
