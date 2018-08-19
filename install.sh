#!/bin/bash

curl -L https://get.rvm.io | bash -s stable --rails
gem install pg
su - postgres
create role myapp with createdb login password 'password1';
rails new myapp --database=postgresql

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
  
rake db:setup  
rails generate scaffold Purchase_Order item_description:string item_no:string qty:string units:string price:string total:string dept:string po_Number:string cardholders_Name:string vendor:string vendor_address:string requested_By:string purpose_Of_Purchase:string date:timestamp
rake db:migrate
rails server
