require 'fox16'
require './app'
require './data_access/DB_client/DB_client.rb'

include Fox

if __FILE__== $0
    DB_client.instance(
        host: ENV['DB_HOST'],
        username: ENV['DB_USERNAME'],
        password: ENV['DB_PASSWORD'],
        database: ENV['DB_NAME']
    )

    app = FXApp.new("Students", "Students")
    App.new(app)
    app.create
    app.run
end