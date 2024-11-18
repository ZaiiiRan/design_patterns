require 'yaml'
require './models/student/student'
require './models/data_storage_strategy/data_storage_strategy.rb'

class YAML_storage_strategy < Data_storage_strategy
    # read from yaml file
    def read(file_path)
        return [] unless File.exist?(file_path)
        data = YAML.safe_load(File.read(file_path), permitted_classes: [Date, Symbol]) || []
        data.map do |student| 
            Student.new_from_hash(student) 
        end
    end

    # read to yaml file
    def write(file_path, students)
        data = students.map { |student| student.to_h }
        File.write(file_path, data.to_yaml)
    end
end