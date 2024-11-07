require 'json'
require './student'
require './student_short'
require './data_list_student_short'

class Students_list_JSON
    # constructor
    def initialize(file_path)
        self.file_path = file_path
        self.students = read
    end

    # read from json file
    def read
        return [] unless File.exist?(self.file_path)
        JSON.parse(File.read(self.file_path), symbolize_names: true).map do |data|
            Student.new(**data)
        end
    end

    # read to json file
    def write
        data = self.students.map { |student| student.to_h }
        File.write(self.file_path, JSON.pretty_generate(data))
    end

    # get student by id
    def get_student_by_id(id)
        self.students.find { |student| student.id == id }
    end

    # get data_list_student_short of k n students
    def get_k_n_student_short_list(k, n, data_list = nil)
        start = (k - 1) * n
        selected = self.students[start, n] || []
        students_short = self.students[start, n].map { |student| Student_short.new_from_student_obj(student) }
        data_list ||= Data_list_student_short.new(selected)
        data_list
    end

    # sort by full name
    def sort_by_full_name!
        self.students.sort_by! { |student| student.get_full_name }
    end

    # add student
    def add_student(student)
        max_id = self.students.map(&:id).max || 0
        student.id = max_id + 1
        self.students << student
    end

    # replace student by id
    def replace_student(id, new_student)
        index = self.students.find_index { |student| student.id == id }
        raise IndexError, 'Unknown student id' unless index
        new_student.id = id
        self.students[index] = new_student
    end

    # delete student by id
    def delete_student(id)
        self.students.reject! { |student| student.id == id }
    end

    # get coung of students
    def get_student_short_count
        self.students.size
    end

    private
    attr_accessor :file_path, :students
end