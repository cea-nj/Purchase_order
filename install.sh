#!/bin/bash


apt-get update -y
apt-get upgrade -y
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update
sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn

cd
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exec $SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
exec $SHELL

rbenv install 2.5.1
rbenv global 2.5.1
ruby -v

gem install bundler
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs -y
gem install rails -v 5.2.0
rbenv rehash
rails -v

sudo sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql-common -y
sudo apt-get install postgresql-9.5 libpq-dev -y

sudo -u postgres createuser chris -s

# If you would like to set a password for the user, you can do the following
sudo -u postgres psql
postgres=# \password chris

rails new myapp -d postgresql
cd myapp
rake db:create

cat << EOF>> myapp/config/database.yml

default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see Rails configuration guide
  # http://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: myapp
  password: password1

development:
  <<: *default
  database: myapp_development
  
  test:
  <<: *default
  database: myapp_test
  
  production:
  <<: *default
  database: myapp_production
  username: myapp
  password: <%= ENV['MYAPP_DATABASE_PASSWORD'] %>
EOF
  
rails generate scaffold Purchase_Order item_description:string item_no:string qty:string units:string price:string total:string dept:string po_Number:string cardholders_Name:string vendor:string vendor_address:string requested_By:string purpose_Of_Purchase:string date:timestamp
rake db:migrate
rails server
