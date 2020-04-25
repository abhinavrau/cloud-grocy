#!/bin/bash
set -e
wget -O ./dbxcli https://github.com/dropbox/dbxcli/releases/download/v3.0.0/dbxcli-linux-amd64
sudo chmod a+x ./dbxcli
if ./dbxcli account; then
  mkdir -p restore
  # get the backup contents
  ./dbxcli get grocy_backup/grocy.db restore/grocy.db
  sudo docker exec -it grocy cp /var/www/data/grocy.db /var/www/data/grocy.db.backup
  sudo docker cp restore/grocy.db grocy:/var/www/data/grocy.db
  sudo docker exec -it --user 0 grocy chown www-data:www-data /var/www/data/grocy.db
  sudo docker-compose restart
else
  echo "Error: dbxcli not configured for restorting. Database not restored." 1>&2
  exit 1

fi


