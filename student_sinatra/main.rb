require 'student_mvp'
require 'dotenv/load'
require 'sinatra'
require './view_classes/base_views/student_list_view.rb'
require './view_classes/base_views/base_view_factory.rb'
require './view_classes/modal/modal_factory.rb'

class App < Sinatra::Base
    App_logger.instance(ENV['LOG_FILE_PATH'])
    DB_client.instance(
        host: ENV['DB_HOST'],
        username: ENV['DB_USERNAME'],
        password: ENV['DB_PASSWORD'],
        database: ENV['DB_NAME']
    )

    configure do
        set :view, Base_view_factory.create_view(:student_list)
        set :modal, nil
    end

    get '/' do
        settings.view.refresh_data
        erb :index
    end

    post '/' do
        filters = JSON.parse(request.body.read)
            
            filters.each do |key, value|
                if settings.view.filters[key]
                    settings.view.filters[key][:text_field].text = value["text"]
                    settings.view.filters[key][:combo].currentItem = value["option"].to_i unless settings.view.filters[key][:combo].nil?
                end
            end
        

        settings.view.on_update
        redirect '/'
    end

    post '/switch_page' do
        direction = params[:direction].to_i
        settings.view.switch_page(direction)
        redirect '/'
    end

    post '/sort' do
        puts params[:column_index].to_i
        column_index = params[:column_index].to_i

        settings.view.on_sort(column_index)
        redirect '/'
    end

    post '/select_rows' do
        selected = JSON.parse(request.body.read)
        settings.view.on_select(selected["selected"])
    end

    delete '/' do
        settings.view.on_delete

        redirect '/'
    end

    post '/modal' do
        mode = params['mode'].to_sym
        settings.modal = Modal_factory.create_modal(settings.view.presenter, mode)
        
        erb :'modal_partial', locals: { modal: settings.modal }
    end

    post '/validate_modal' do
        request_payload = JSON.parse(request.body.read)
        request_payload.each do |field_name, text|
            settings.modal.fields[field_name].text = text
        end
        settings.modal.enable_ok_btn

        { valid: settings.modal.ok_btn }.to_json
    end

    post '/modal_submit' do
        request_payload = JSON.parse(request.body.read)
        request_payload.each do |field_name, text|
            settings.modal.fields[field_name].text = text
        end

        settings.modal.operation

        if !settings.modal.error_msg.nil? && !settings.modal.error_msg.empty?
            status 400
            settings.modal.error_msg
        else
            redirect '/'
        end
    end
end


App.run!
