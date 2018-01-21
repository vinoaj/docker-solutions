# Purpose
Builds a working Wordpress + MySQL environment along with:
+ `certbot` installation and configuration
+ Set twice daily cron task for `certbot-auto`
+ Installation of Stackdriver monitoring agent
+ 

# Instructions
+ `cp wordpress.env.template wordpress.env`
+ Edit `wordpress.env` and set your desired usernames & passwords
+ Make sure `wordpress.env` is saved
+ `docker compose up` 
