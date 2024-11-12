require './student'
require './student_short'
require './data_list_student_short'
require './binary_tree.rb'

class Students_list
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
    def get_k_n_student_short_list(k, n, data_list = nil)
        start = (k - 1) * n
        selected = self.students[start, n] || []
        students_short = selected.map { |student| Student_short.new_from_student_obj(student) }
        data_list ||= Data_list_student_short.new(students_short)
        data_list.index = start + 1
        data_list
    end

    # sort by full name
    def sort_by_full_name!
        self.students.sort_by! { |student| student.get_full_name }
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
    end

    # replace student by id
    def replace_student(id, new_student)
        current_student = self.students.find { |student| student.id == id }
        raise IndexError, 'Unknown student id' if current_student.nil?
        begin
            check_unique_fileds(email: new_student.email, telegram: new_student.telegram, 
                phone_number: new_student.phone_number, git: new_student.git, current_student: current_student)
        rescue => e
            raise e
        end
        new_student.id = id
        student = new_student
    end

    # delete student by id
    def delete_student(id)
        self.students.reject! { |student| student.id == id }
    end

    # get count of students
    def get_student_short_count
        self.students.size
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
