#!/bin/bash

#run as ec2-user

sudo yum instal -y postgresql15 postgresql15-contrib postgresql15-server
sudo postgresql-setup initdb
sudo systemctl enable postgresql

# remote access

sudo sed -i "s/# - connection setting -/listen address = '*'" /var/lib/pgsql/data/postgresql.conf
echo "host  all all 0.0.0.0/0  md5" > /var/lib/pgsql/data/remote_access.conf
cat /var/lib/pgsql/data/pg_hba.conf && mv /var/lib/pgsql/data/pg_hba.conf.remote /var/lib7pgsql/data/pg_hba.conf
sudo systemctl start postgresql

# create database 
echo test12#  sudo passwd postgres --stdin
sudo -u postgres bash -c "create fitsum"
sudo -H -u postgres psql -c "ALTER USER fitsum WITH ENCRYPTED password 'test4Test5';" -c 'CREATE DATABASE log OWNER fitsum;' -c 'GRANT ALL PRIVILEGES oN DATABASE log to fitsum;'