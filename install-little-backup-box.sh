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

sudo apt update
sudo apt dist-upgrade -y
sudo apt install acl git-core screen rsync exfat-fuse exfat-utils ntfs-3g gphoto2 libimage-exiftool-perl dialog wiringpi python3-pip -y
sudo apt update
sudo pip3 install bottle

#sudo curl https://rclone.org/install.sh | sudo bash

sudo mkdir /media/card
sudo mkdir /media/microsd
sudo mkdir /media/storage
sudo chown -R pi:pi /media/storage
sudo chmod -R 775 /media/storage
sudo setfacl -Rdm g:pi:rw /media/storage

cd
git clone https://github.com/monoetharyus/little-backup-box.git

cd little-backup-box/fonts
sudo cp -R . /home/pi/.fonts
cd

HEIGHT=15
WIDTH=80
CHOICE_HEIGHT=5
BACKTITLE="Little Backup Box"
TITLE="Backup mode"
MENU="Select the default backup mode:"

OPTIONS=(1 "Remote control"
		 2 "Telegram Bot control"
         3 "Card backup (Backup from card reader to external storage)"
         4 "Camera backup (Backup from camera to internal storage)"
         5 "Device backup (Backup from device to internal storage)" )

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            crontab -l | { cat; echo "@reboot gpio -g mode 21 out && gpio -g write 21 1"; } | crontab
            crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/scripts/card-backup.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/scripts/camera-backup.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/scripts/reader-backup.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "@reboot sudo /home/pi/little-backup-box/scripts/rc.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "#@reboot java -jar /home/pi/little-backup-box/LittleBackupBot-1.0.0.jar >> /home/pi/little-backup-box.log 2>&1"; } | crontab
        ;;
        2)
            crontab -l | { cat; echo "@reboot gpio -g mode 21 out && gpio -g write 21 1"; } | crontab
            crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/scripts/card-backup.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/scripts/camera-backup.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/scripts/reader-backup.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/scripts/rc.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "@reboot java -jar /home/pi/little-backup-box/LittleBackupBot-1.0.0.jar >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            
           	CONFIG_FILE="/home/pi/little-backup-box/config/little-backup-bot.properties"
            mkdir -p /home/pi/little-backup-box/config
            
            TOKEN=$(dialog --title "Configurating Telegram Bot" --inputbox "Enter TOKEN" 8 40)
            echo 'bot.token:"'$TOKEN'"' >> $CONFIG_FILE
            USERNAME=$(dialog --title "Configurating Telegram Bot" --inputbox "Enter USERNAME" 8 40)
            echo 'bot.username:"'$USERNAME'"' >> $CONFIG_FILE
            CREATOR_ID=$(dialog --title "Configurating Telegram Bot" --inputbox "Enter CREATOR_ID" 8 40)
            echo 'bot.username:"'$CREATOR_ID'"' >> $CONFIG_FILE           
        ;;
        3)
            crontab -l | { cat; echo "@reboot gpio -g mode 21 out && gpio -g write 21 1"; } | crontab
            crontab -l | { cat; echo "@reboot sudo /home/pi/little-backup-box/scripts/card-backup.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/scripts/camera-backup.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/scripts/reader-backup.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/scripts/rc.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "#@reboot java -jar /home/pi/little-backup-box/LittleBackupBot-1.0.0.jar >> /home/pi/little-backup-box.log 2>&1"; } | crontab
        ;;
        4)
            crontab -l | { cat; echo "@reboot gpio -g mode 21 out && gpio -g write 21 1"; } | crontab
            crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/scripts/card-backup.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "@reboot sudo /home/pi/little-backup-box/scripts/camera-backup.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "@reboot sudo /home/pi/little-backup-box/scripts/reader-backup.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/scripts/rc.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "#@reboot java -jar /home/pi/little-backup-box/LittleBackupBot-1.0.0.jar >> /home/pi/little-backup-box.log 2>&1"; } | crontab
        ;;
        5)
            crontab -l | { cat; echo "@reboot gpio -g mode 21 out && gpio -g write 21 1"; } | crontab
            crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/scripts/card-backup.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/scripts/camera-backup.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "@reboot sudo /home/pi/little-backup-box/scripts/reader-backup.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "#@reboot sudo /home/pi/little-backup-box/scripts/rc.sh >> /home/pi/little-backup-box.log 2>&1"; } | crontab
            crontab -l | { cat; echo "#@reboot java -jar /home/pi/little-backup-box/LittleBackupBot-1.0.0.jar >> /home/pi/little-backup-box.log 2>&1"; } | crontab
        ;;
esac

echo "---------------------------------------------"
echo "All done! The system will reboot in 1 minute."
echo "---------------------------------------------"

sudo shutdown -r 1
