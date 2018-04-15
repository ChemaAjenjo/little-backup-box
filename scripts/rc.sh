#!/bin/bash

#!/usr/bin/env bash

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

STORAGE_MOUNT_POINT="/media/storage" # Mont point of the storage device

# If there is a wpa_supplicant.conf file in the root of the storage device
# Rename the original config file,
# move wpa_supplicant.conf from the card to /etc/wpa_supplicant/
# Reboot to enable networking
if [ -f "$STORAGE_MOUNT_POINT/wpa_supplicant.conf" ]; then
    mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf.bak
    mv "$STORAGE_MOUNT_POINT/wpa_supplicant.conf" /etc/wpa_supplicant/wpa_supplicant.conf
    reboot
fi

while :
do
  if [[ ! $(pgrep -f rc.py) ]]; then
    cd /home/pi/little-backup-box/rc/
    sudo python3 rc.py
  fi
done 
