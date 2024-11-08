require 'mysql2'
require './student'
require './student_short'
require './data_list_student_short.rb'

class Students_list_DB
    # constructor
    def initialize(db_config)
        self.db = Mysql2::Client.new(db_config)
    end

    def get_student_by_id(id)
        result = self.db.prepare("SELECT * FROM student WHERE id = ?").execute(id)
        row = result.first
        return nil unless row

        Student.new_from_hash(row)
    end

    def get_k_n_student_short_list(k, n, data_list = nil)
        start = (k - 1) * n
        result = self.db.prepare("SELECT * FROM student LIMIT ? OFFSET ?").execute(n, start)
        students_short = result.map { |row| Student_short.new_from_student_obj(Student.new_from_hash(row)) }
        data_list ||= Data_list_student_short.new(students_short)
        data_list
    end

    def add_student(student)
        query = <<-SQL
            INSERT INTO student (first_name, name, patronymic, birthdate, telegram, email, phone_number, git)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        SQL
        self.db.prepare(query).execute(
            student.first_name,
            student.name,
            student.patronymic,
            student.birthdate,
            student.telegram,
            student.email,
            student.phone_number,
            student.git
        )
    end

    def replace_student(id, new_student)
        query = <<-SQL
            UPDATE student
            SET first_name = ?, name = ?, patronymic = ?, birthdate = ?, telegram = ?, email = ?, phone_number = ?, git = ?
            WHERE id = ?
        SQL
        self.db.prepare(query).execute(
            new_student.first_name,
            new_student.name,
            new_student.patronymic,
            new_student.birthdate,
            new_student.telegram,
            new_student.email,
            new_student.phone_number,
            new_student.git,
            id
        )
    end

    def delete_student(id)
        query = "DELETE FROM student WHERE id = ?"
        self.db.prepare(query).execute(id)
    end

    def get_student_short_count
        result = self.db.query("SELECT COUNT(*) AS count FROM student")
        result.first['count']
    end

    private
    attr_accessor :db
end