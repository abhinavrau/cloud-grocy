#!/bin/bash
sudo apt-get install cron
if [[ $(crontab -l | egrep -v "^(#|$)" | grep -q 'grocy-backup.sh'; echo $?) == 1 ]]
then
    echo $(crontab -l ; echo '@daily /home/ubuntu/grocy-backup.sh >> /home/ubuntu/grocy-backup.log 2>&1') | crontab -
fi

