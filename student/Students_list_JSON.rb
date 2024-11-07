require 'json'
require './student'
require './Students_list.rb'

class Students_list_JSON < Students_list
    # read from json file
    def read
        return [] unless File.exist?(self.file_path)
        data = JSON.parse(File.read(self.file_path), symbolize_names: true) rescue []
        data.map do |data|
            Student.new(**data)
        end
    end

    # read to json file
    def write
        data = self.students.map { |student| student.to_h }
        File.write(self.file_path, JSON.pretty_generate(data))
    end
end