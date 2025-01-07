require './data_access/db_client/db_client.rb'
require 'dotenv/load'
require './app.rb'
require 'fox16'

include Fox

if __FILE__ == $0
  DB_client.instance(
    host: ENV['DB_HOST'],
    username: ENV['DB_USERNAME'],
    password: ENV['DB_PASSWORD'],
    database: ENV['DB_NAME']
  )

  app = FXApp.new('Отель', 'Отель')
  App.new(app)
  app.create
  app.run
end