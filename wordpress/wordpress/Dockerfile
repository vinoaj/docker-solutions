# Use the official WordPress image as the base image
FROM wordpress:latest
LABEL maintainer="vinoaj@gmail.com"

# apt-get switches:
#  -qq : full quiet mode
#  -y: automatic "yes" to prompts

# RUN \
#     apt-get update -y && \
#     apt-get upgrade -y && \
#     apt-get install -y stackdriver-agent && \
#     apt-get clean

# RUN \
#     curl -sSO https://repo.stackdriver.com/stack-install.sh && \
#     bash stack-install.sh --write-gcm && \
#     curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh && \
#     bash install-logging-agent.sh

# Install required packages
RUN \
    echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y python-certbot-apache -t stretch-backports \
    && apt-get install -y cron
    # certbot --apache

# RUN \
#     certbot certonly --webroot \
#     --email vinoaj@vinoaj.com --agree-tos \
#     -d xyz.com
#     # -w /var/www/letsencrypt -d xyz.com

# RUN \
#     certbot certonly \
#     --agree-tos \
#     --non-interactive \
#     --text \
#     --rsa-key-size 4096 \
#     --email vinoaj@vinoaj.com \
#     --webroot \
#     -w /var/www/html \
#     -d xyz.com

# Add cron jobs to auto-renew LetsEncrypt SSL certificates
RUN \
    touch /var/spool/cron/crontabs/root \
    && (crontab -l \
        && echo "0 0 * * * ./certbot-auto renew --quiet --no-self-upgrade\n" \
        && echo "0 12 * * * ./certbot-auto renew --quiet --no-self-upgrade\n" \
    ) | crontab -

# Create a standard robots.txt file
RUN \
    touch /var/www/html/robots.txt \
    && echo "User-agent: *\nDisallow:" >> /var/www/html/robots.txt

# Clean up: remove all packages from the package cache
RUN \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Volume for LetsEncrypt
VOLUME /etc/letsencrypt/