require 'json'
require './student'
require './data_storage_strategy.rb'

class JSON_storage_strategy < Data_storage_strategy
    # read from json file
    def read(file_path)
        return [] unless File.exist?(file_path)
        data = JSON.parse(File.read(file_path), symbolize_names: true) rescue []
        data.map do |data|
            Student.new(**data)
        end
    end

    # read to json file
    def write(file_path, students)
        data = students.map { |student| student.to_h }
        File.write(file_path, JSON.pretty_generate(data))
    end
end