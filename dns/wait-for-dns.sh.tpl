#!/bin/bash
set -e
current=`ec2metadata --public-ipv4`
echo "public-ipv4 of host is: $current"
echo url="https://www.duckdns.org/update?domains=${duckdns_domain}&token=${duckdns_token}&ip=" \
    | curl -s -k -K - | grep 'OK' && \
    echo "Successfully registered ${duckdns_domain}.duckdns.org with public IP address $current with DuckDNS." \
    || (echo "Failed to register with DuckDNS. Ensure the token and domain supplied are entered correct." ; exit 1)

until [ "$(dig +short -t A ${duckdns_domain}.duckdns.org)" == "$current" ]; \
   do echo "DNS for ${duckdns_domain}.duckdns.org does not resolve to $current yet. Checking after 5 seconds.." && sleep 5; done \
   && echo "DNS for ${duckdns_domain}.duckdns.org successfully propogated."