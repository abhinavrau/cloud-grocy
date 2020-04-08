#!/bin/sh
# Docker Compose
sudo wget \
        --output-document=/usr/local/bin/docker-compose \
        https://github.com/docker/compose/releases/download/1.25.4/run.sh \
    && sudo chmod +x /usr/local/bin/docker-compose \
    && sudo wget \
        --output-document=/etc/bash_completion.d/docker-compose \
        "https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose" \
    && printf '\nDocker Compose installed successfully\n\n'