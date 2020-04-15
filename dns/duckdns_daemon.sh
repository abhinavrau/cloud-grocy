#!/bin/bash
# registers DNS as a background process
su - ubuntu -c "nohup ~/dns/register-duckdns.sh > ~/dns/duck.log 2>&1&"