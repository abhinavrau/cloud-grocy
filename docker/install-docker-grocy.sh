#!/bin/sh
sudo docker pull grocy/grocy-docker:nginx
sudo docker pull grocy/grocy-docker:grocy
sudo docker-compose up -d
