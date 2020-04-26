#
# Network name
#
# Your container app must use a network conencted to your webproxy
# https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion
#
NETWORK=webproxy

# Your domain (or domains)
DOMAINS=${domain_name}

# Your email for Let's Encrypt register
LETSENCRYPT_EMAIL=aaa@aaa.com
