#!/bin/bash
set -e
cd /home/ubuntu
wget -O ./dbxcli https://github.com/dropbox/dbxcli/releases/download/v3.0.0/dbxcli-linux-amd64
sudo chmod a+x ./dbxcli
if ./dbxcli account; then
  mkdir -p backup
  sudo docker exec --user=root grocy apk add sqlite
  sudo docker exec --user=root grocy sqlite3 /var/www/data/grocy.db ".backup 'backup_grocy.db'"
  sudo docker cp grocy:/var/www/backup_grocy.db backup/grocy.db
  # Ignore any errors here since directory may have already been created
  set +e
  ./dbxcli mkdir grocy_backup
  set -e
  # upload the backups
  ./dbxcli put backup/grocy.db grocy_backup/grocy.db
else
  echo "dbxcli not configured. Backups will not be done. Please configure dropbox to enable backups." 1>&2
  exit 1
fi


