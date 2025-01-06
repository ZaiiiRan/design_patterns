require './data_access/db_client/db_client.rb'
require 'dotenv/load'

if __FILE__ == $0
  DB_client.instance(
    host: ENV['DB_HOST'],
    username: ENV['DB_USERNAME'],
    password: ENV['DB_PASSWORD'],
    database: ENV['DB_NAME']
  )
end