#!/bin/bash
current=""
while true; do
	latest=`ec2metadata --public-ipv4`
	echo "public-ipv4=$latest"
	if [ "$current" == "$latest" ]
	then
		echo "ip not changed"
	else
		echo "ip has changed - updating"
		current=$latest
		echo url="https://www.duckdns.org/update?domains=${grocy_domain_name},${bbuddy_domain_name}&token=${duckdns_token}&ip=" | curl -k -o ~/dns/duck.log -K -
	fi
	sleep 5m
done

