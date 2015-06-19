#!/bin/bash

# Deps
apt-get update && apt-get install -y \
libbz2-dev \
libcurl4-openssl-dev \
libevent-dev \
libffi-dev \
libglib2.0-dev \
libicu-dev \
libjpeg-dev \
liblzma-dev \
libmagickcore-dev \
libmagickwand-dev \
libmysqlclient-dev \
libncurses-dev \
libpq-dev \
libreadline-dev \
libsqlite3-dev \
libssl-dev \
libxml2-dev \
libxslt-dev \
libyaml-dev \
zlib1g-dev

# Tools
git clone https://github.com/sstephenson/rbenv.git /home/vagrant/.rbenv
git clone https://github.com/sstephenson/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
git clone https://github.com/sstephenson/rbenv-gem-rehash.git /home/vagrant/.rbenv/plugins/rbenv-gem-rehash
chown -R vagrant:vagrant /home/vagrant/.rbenv

# Settings
echo '# RUBY SETTINGS' >> /home/vagrant/.bashrc
echo 'export PATH="/home/vagrant/.rbenv/bin:$PATH"' >> /home/vagrant/.bashrc
echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc

# Ruby
export PATH="/home/vagrant/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
su - vagrant -c "rbenv install 2.1.5 -k"
su - vagrant -c "rbenv global 2.1.5"
su - vagrant -c "gem install bundle"

# nodejs
curl -sL https://deb.nodesource.com/setup | bash -
apt-get install -y nodejs

# Redis
apt-get install -y redis-server

# PostgreSQL
apt-get install -y postgresql postgresql-client
su - postgres -c "createuser vagrant --no-superuser --createdb --no-createrole"
su - postgres -c "createdb vagrant"

# App setup
echo -e "RACK_ENV=development\nRAILS_ENV=development\nPORT=3000" > /home/vagrant/source/.env
su - vagrant -c "cd /home/vagrant/source && bundle install"
su - vagrant -c "cd /home/vagrant/source && rake db:setup"
su - vagrant -c "cd /home/vagrant/source && nohup foreman start &"
