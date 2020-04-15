#!/bin/bash
echo "Registering IP address with DuckDNS and wait for DNS to propagate for 5 minutes"
timeout 5m ./wait-for-dns.sh &&  echo "Public IP registered in DNS successfully." || exit 1;

# Register the daemon to check for IP address change.
chmod +x duckdns_daemon.sh
sudo chown root duckdns_daemon.sh
sudo chmod 744 duckdns_daemon.sh
# Make sure it start on boot
sudo ln -s ~/dns/duckdns_daemon.sh /etc/rc2.d/S10duckdns
# Start the daemon
sudo /etc/rc2.d/S10duckdns
echo "Registered and Started daemon to check for IP address change"
