require './models/student/student'
require './models/student_short/student_short'
require './models/data_list/data_list_student_short'
require './models/binary_tree/binary_tree.rb'
require './models/students_list/students_list_interface.rb'

class Students_list_file < Students_list_interface
    # constructor
    def initialize(file_path, data_storage_strategy)
        self.file_path = file_path
        self.data_storage_strategy = data_storage_strategy
        self.students = read
    end

    # read from data storage
    def read
        self.data_storage_strategy.read(self.file_path)
    end

    # write to data storage
    def write
        self.data_storage_strategy.write(self.file_path, self.students)
    end

    # get student by id
    def get_student_by_id(id)
        self.students.find { |student| student.id == id }
    end

    # get data_list_student_short of k n students
    def get_k_n_student_short_list(k, n, filter = nil, data_list = nil)
        start = (k - 1) * n
        filtered = filter ? filter.apply(self.students) : self.students
        selected = filtered[start, n] || []
        students_short = selected.map { |student| Student_short.new_from_student_obj(student) }
        data_list ||= Data_list_student_short.new(students_short)
        data_list.index = start + 1
        data_list.data = students_short
        data_list
    end

    # sort by full name
    def sort_by_full_name!
        self.students.sort_by! { |student| student.get_full_name }
        self.write
    end

    # add student
    def add_student(student)
        begin
            check_unique_fileds(email: student.email, telegram: student.telegram, phone_number: student.phone_number, git: student.git)
        rescue => e
            raise e
        end
        max_id = self.students.map(&:id).max || 0
        student.id = max_id + 1
        self.students << student
        self.write
    end

    # replace student by id
    def replace_student(id, new_student)
        index = self.students.find_index { |student| student.id == id }
        raise IndexError, 'Unknown student id' if index.nil?
        begin
            check_unique_fileds(email: new_student.email, telegram: new_student.telegram, 
                phone_number: new_student.phone_number, git: new_student.git, current_student: self.students[index])
        rescue => e
            raise e
        end
        new_student.id = id
        self.students[index] = new_student
        self.write
    end

    # delete student by id
    def delete_student(id)
        self.students.reject! { |student| student.id == id }
        self.write
    end

    # get count of students
    def get_student_short_count(filter = nil)
        filter ? filter.apply(self.students).size : self.students.size
    end

    private
    attr_accessor :file_path, :students, :data_storage_strategy

    def check_unique_fileds(email: nil, telegram: nil, phone_number: nil, git: nil, current_student: nil)
        if !email.nil? && (current_student.nil? || email != current_student.email) && !unique_email?(email)
            raise 'Duplicate email'
        end

        if !telegram.nil? && (current_student.nil? || telegram != current_student.telegram) && !unique_telegram?(telegram)
            raise 'Duplicate telegram'
        end

        if !phone_number.nil? && (current_student.nil? || phone_number != current_student.phone_number) && !unique_phone_number?(phone_number)
            raise 'Duplicate phone number'
        end

        if !git.nil? && (current_student.nil? || git != current_student.git) && !unique_git?(git)
            raise 'Duplicate git'
        end
    end

    def unique_email?(email)
        unique?(:email, email)
    end

    def unique_telegram?(telegram)
        unique?(:telegram, telegram)
    end

    def unique_phone_number?(phone_number)
        unique?(:phone_number, phone_number)
    end

    def unique_git?(git)
        unique?(:git, git)
    end

    def unique?(key_type, key)
        tree = Binary_tree.new
        self.students.each do |student|
            student.key_type = key_type
            tree.add(student)
        end

        finded = tree.find(key)
        return finded.nil?
    end
end