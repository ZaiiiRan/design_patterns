require './students_list/students_list_DB.rb'
require './students_list/students_list_interface.rb'

class Students_list_DB_adapter < Students_list_interface
    def initialize
        self.students_list = Students_list_DB.new
    end

    def get_student_by_id(id)
        self.students_list.get_student_by_id(id)
    end

    def get_k_n_student_short_list(k, n, data_list = nil)
        self.students_list.get_k_n_student_short_list(k, n, data_list)
    end

    def add_student(student)
        self.students_list.add_student(student)
    end

    def replace_student(id, new_student)
        self.students_list.replace_student(id, new_student)
    end

    def delete_student(id)
        self.students_list.delete_student(id)
    end

    def get_student_short_count
        self.students_list.get_student_short_count
    end

end