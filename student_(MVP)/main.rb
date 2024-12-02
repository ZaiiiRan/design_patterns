require 'fox16'
require 'student_mvp'
require_relative './app.rb'
require 'dotenv/load'

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