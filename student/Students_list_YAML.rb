require 'yaml'
require './student'
require './Students_list.rb'

class Students_list_YAML < Students_list
    # read from yaml file
    def read
        return [] unless File.exist?(self.file_path)
        data = YAML.safe_load(File.read(self.file_path), permitted_classes: [Date, Symbol]) || []
        data.map { |student| Student.new(**student) }
    end

    # read to yaml file
    def write
        data = self.students.map { |student| student.to_h }
        File.write(self.file_path, data.to_yaml)
    end
end