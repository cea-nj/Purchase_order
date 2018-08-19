\curl -L https://get.rvm.io | bash -s stable --rails
gem install pg
su - postgres
create role myapp with createdb login password 'password1';
rails new myapp --database=postgresql
development:
  adapter: postgresql
  encoding: unicode
  database: myapp_development
  pool: 5
  username: myapp
  password: password1
  
  rake db:setup
  
  rails generate scaffold Purchase_Order item_description:string item_no:string qty:string units:string price:string total:string dept:string po_Number:string cardholders_Name:string vendor:string vendor_address:string requested_By:string purpose_Of_Purchase:string date:timestamp
rake db:migrate
rails server
