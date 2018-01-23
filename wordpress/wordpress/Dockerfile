# Use the official WordPress image as the base image
FROM wordpress:latest
LABEL maintainer="vinoaj@gmail.com"

ARG DOMAIN

# apt-get switches:
#  -qq : full quiet mode
#  -y: automatic "yes" to prompts
# Install required packages
RUN \
    echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y apt-utils \
    && apt-get install -y \
        cron \
        lsb \
        gnupg2 \
    && apt-get install -y python-certbot-apache -t stretch-backports 

# Clean up: remove all packages from the package cache
RUN \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Ensure Google Cloud credentials are in place for Stackdriver
RUN mkdir -p /etc/google/auth
COPY credentials.json /etc/google/auth/application_default_credentials.json
RUN chown root:root /etc/google/auth/application_default_credentials.json \
    && chmod 0400 /etc/google/auth/application_default_credentials.json

# Install Stackdriver monitoring and logging agents
RUN \
    curl -sSO https://dl.google.com/cloudagents/install-monitoring-agent.sh \
    && bash install-monitoring-agent.sh \
    && curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh \
    && bash install-logging-agent.sh

# Implement LetsEncrypt SSL certificate using certbot
RUN \
    certbot certonly \
    --agree-tos \
    --non-interactive \
    --text \
    --rsa-key-size 4096 \
    --email vinoaj@vinoaj.com \
    --webroot \
    -w /var/www/html \
    -d $DOMAIN

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

# Volume for LetsEncrypt
VOLUME /etc/letsencrypt/

# Manipulating apache2 files
# - Modify rewrite rules to allow /server-status to run interference-free for Stackdriver
# - Replace default conf file to do HTTP -> HTTPS redirect
COPY .htaccess /var/www/html/.htaccess
# Not proud of this clunky hack, but it works!
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN \
    replstr='s/$DOMAINREPL/' \
    && repl="$DOMAIN/" \
    && expr=$replstr$repl \
    && sed -i -e $expr /etc/apache2/sites-available/000-default.conf
