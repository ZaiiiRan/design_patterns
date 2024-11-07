require './student'
require './student_short'
require './data_list_student_short'

class Students_list
    # constructor
    def initialize(file_path)
        self.file_path = file_path
        self.students = read
    end

    # read from file
    def read
        raise NotImplementedError, 'This method should be implemented in a subclass'
    end

    # write to file
    def write
        raise NotImplementedError, 'This method should be implemented in a subclass'
    end

    # get student by id
    def get_student_by_id(id)
        self.students.find { |student| student.id == id }
    end

    # get data_list_student_short of k n students
    def get_k_n_student_short_list(k, n, data_list = nil)
        start = (k - 1) * n
        selected = self.students[start, n] || []
        students_short = selected.map { |student| Student_short.new_from_student_obj(student) }
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

    # get count of students
    def get_student_short_count
        self.students.size
    end

    protected
    attr_accessor :file_path, :students
end
