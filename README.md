# Little Backup Box

Bash shell scripts that transform a Raspberry Pi (or any single-board computer running a Debian-based Linux distribution) into an inexpensive, fully-automatic, pocketable photo backup and streaming device.

<img src="https://i.imgur.com/OQ3AQfM.jpg" alt="" width="375"/>

## Installation

First of all, make sure that your Raspberry Pi is connected to the internet.

Run the following command on the Raspberry Pi:

    curl -sSL https://goo.gl/btmpKd | bash

When prompted, reboot the Raspberry Pi.

By default, Little Backup Box is configured to back up storage cards. To make the script transfer files directly from the connected camera, run the `crontab -e` command on Raspberry Pi. Comment the following line by prepending *#* to it:

    @reboot sudo /home/pi/little-backup-box/backup.sh > /home/pi/little-backup-box.log

Uncomment then the line below by removing *#*:

    #@reboot sudo /home/pi/little-backup-box/gphoto-backup.sh > /home/pi/gphoto-backup.log

Save the changes.

## Usage

1. Boot the Raspberry Pi
2. Plug in the backup storage device (or camera, if you configured Little Backup Box as described above)
3. Plug in the card reader and wait till the Raspberry Pi shuts down

To geocorrelate the backed up photos, place a GPX file in the root of the storage device before plugging it into the Raspberry Pi.

**Note:** To differentiate between different storage cards, the backup script creates a datetime-based *.id* file in the root of each storage card. The name of the *.id* file is also used as the destination backup folder on the storage device.

## Problems?

Please report bugs and issues in the [Issues](https://github.com/dmpop/little-backup-box/issues) section.

## Contribute

If you've found a bug or have a suggestion for improvement, open an issue in the [Issues](https://github.com/dmpop/little-backup-box/issues) section.

To add a new feature or fix issues yourself, follow the following steps.

1. Fork the project's repository repository
2. Create a feature branch using the `git checkout -b new-feature` command
3. Add your new feature or fix bugs and run the `git commit -am 'Add a new feature'` command to commit changes
4. Push changes using the `git push origin new-feature` command
5. Submit a pull request

## Author

Dmitri Popov [dmpop@linux.com](mailto:dmpop@linux.com)

## License

The [GNU General Public License version 3](http://www.gnu.org/licenses/gpl-3.0.en.html)

## Linux Photography

Little Backup Box is a part of a streamlined and automated Linux-based photographic workflow described in the [Linux Photography](https://gumroad.com/l/linux-photography) book. The book provides step-by-step instructions on building a Raspberry Pi-based photo backup device running the Little Backup Box script. Get your copy at [Google Play Store](https://play.google.com/store/books/details/Dmitri_Popov_Linux_Photography?id=cO70CwAAQBAJ) or [Gumroad](https://gumroad.com/l/linux-photography).

<img src="https://scribblesandsnaps.files.wordpress.com/2016/07/linux-photography-6.jpg" width="200"/>

# NEW FUNCTIONALITIES

If you raspberry pi have internet connection, you can send the backup to remote storage through [rclone](https://github.com/ncw/rclone). Please see how configure the remote storage in [rclone documentation](https://rclone.org/). For this you will need modify the property ``REMOTE_PATH`` in ``backup.sh``

Also included commands that notify through [Telegram Bot](https://telegram.org/blog/bot-revolution), for example when the backup is finished the raspberry pi will send you the log. For this you need [create a Telegram bot](https://core.telegram.org/bots#creating-a-new-bot), after change values in ``network.config`` file and put in root of storage

    TOKEN="<token>" # Token of your telegram bot
    CHATID="<chat_id>" # Your user chat_id in Telegram
    LOG="/home/pi/little-backup-box.log" # Log file. IMPORTANT: equals than in crontab
    REMOTE_PATH="remote:backup_dir" # rclone repository
    
