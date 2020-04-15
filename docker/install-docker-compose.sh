#!/bin/sh
# Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" \
 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.25.4/contrib/completion/bash/docker-compose \
-o /etc/bash_completion.d/docker-compose

printf '\nDocker Compose installed successfully\n\n'

sudo docker-compose pull
