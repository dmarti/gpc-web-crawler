#!/bin/bash

cd /srv/analysis/rest-api
echo "running $0 in `pwd`"

set -e
set -x

service mysql start
service mysql status &> /dev/null

# Dink with the MySQL database, find some SQL stuff on Stack Overflow, repeat
# https://github.com/privacy-tech-lab/gpc-web-crawler/wiki/Setting-Up-Local-SQL-Database
# https://stackoverflow.com/questions/50093144/mysql-8-0-client-does-not-support-authentication-protocol-requested-by-server
mysql -v << SQLCOMMANDS || true
ALTER USER root@localhost IDENTIFIED WITH mysql_native_password BY 'toor';
FLUSH PRIVILEGES;
CREATE DATABASE analysis;
USE analysis;
CREATE TABLE entries (id INTEGER PRIMARY KEY AUTO_INCREMENT, site_id INTEGER, domain varchar(255), sent_gpc BOOLEAN, uspapi_before_gpc varchar(255), uspapi_after_gpc varchar(255), usp_cookies_before_gpc varchar(255), usp_cookies_after_gpc varchar(255), OptanonConsent_before_gpc varchar(800), OptanonConsent_after_gpc varchar(800), gpp_before_gpc varchar(4000), gpp_after_gpc varchar(4000), urlClassification varchar(5000));
CREATE TABLE debug (id INTEGER PRIMARY KEY AUTO_INCREMENT, domain varchar(255), a varchar(4000), b varchar(4000));
SQLCOMMANDS

mysql -u root -ptoor -e 'SELECT NOW();' 

# Set up REST API
# https://github.com/privacy-tech-lab/gpc-web-crawler/wiki/How-to-run-REST-API
cat << 'ENVFILE' > .env
DB_CONNECTION=mysql
DB_HOST=localhost
DB_DATABASE=analysis
DB_USERNAME=root
DB_PASSWORD=toor
ENVFILE

npm install

cat << 'SERVICEFILE' > /etc/systemd/system/gpc-restapi.service
[Unit]
Description=REST API service
After=network.target
Requires=mysql.service

[Service]
WorkingDirectory=/srv/analysis/rest-api
ExecStart=/usr/bin/node index.js debug
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICEFILE

systemctl enable gpc-restapi
systemctl start gpc-restapi

set +x
echo '--------------------------------------------------'
echo "REST API started at http://localhost:8080/analysis"
echo '--------------------------------------------------'
