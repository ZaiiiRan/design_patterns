require './models/student/student'
require './models/student_short/student_short'
require './models/data_list/data_list_student_short'
require './models/binary_tree/binary_tree.rb'
require './models/students_list/students_list_interface.rb'

class Students_list_file_adapter < Students_list_interface
    # constructor
    def initialize(adaptee)
        self.adaptee = adaptee
    end

    # get student by id
    def get_student_by_id(id)
        self.adaptee.get_student_by_id(id)
    end

    # get data_list_student_short of k n students
    def get_k_n_student_short_list(k, n, filter = nil, data_list = nil)
        self.adaptee.get_k_n_student_short_list(k, n, filter, data_list)
    end

    # add student
    def add_student(student)
        self.adaptee.add_student(student)
    end

    # replace student by id
    def replace_student(id, new_student)
        self.adaptee.replace_student(id, new_student)
    end

    # delete student by id
    def delete_student(id)
        self.adaptee.delete_student(id)
    end

    # get count of students
    def get_student_short_count(filter = nil)
        self.adaptee.get_student_short_count(filter)
    end

    private
    attr_accessor :adaptee
end