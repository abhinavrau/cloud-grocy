#!/bin/bash
set -e
wget -O dbxcli https://github.com/dropbox/dbxcli/releases/download/v3.0.0/dbxcli-linux-amd64
sudo chmod a+x dbxcli
if dbxcli account; then
  mkdir -p restore
  # get the backup contents
  dbxcli get grocy_backup/grocy.db restore/grocy.db
  sudo docker cp restore/grocy.db grocy:/www/data/grocy.db
else
  echo "Error: dbxcli not configured for restorting. Database not restored." 1>&2
  exit 1

fi


