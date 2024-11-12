require 'mysql2'
require './student/student'
require './student_short/student_short'
require './data_list/data_list_student_short.rb'
require './DB_client/DB_client.rb'
require './students_list/students_list_interface.rb'

class Students_list_DB_adapter < Students_list_interface
    def get_student_by_id(id)
        result = DB_client.instance.query("SELECT * FROM student WHERE id = ?", [id])
        row = result.first
        return nil unless row

        Student.new_from_hash(row)
    end

    def get_k_n_student_short_list(k, n, data_list = nil)
        start = (k - 1) * n
        result = DB_client.instance.query("SELECT * FROM student LIMIT ? OFFSET ?", [n, start])
        students_short = result.map { |row| Student_short.new_from_student_obj(Student.new_from_hash(row)) }
        data_list ||= Data_list_student_short.new(students_short)
        data_list.index = start + 1
        data_list
    end

    def add_student(student)
        query = <<-SQL
            INSERT INTO student (first_name, name, patronymic, birthdate, telegram, email, phone_number, git)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        SQL

        begin
            DB_client.instance.query(query, [
                student.first_name,
                student.name,
                student.patronymic,
                student.birthdate,
                student.telegram,
                student.email,
                student.phone_number,
                student.git
            ])
        rescue Mysql2::Error => e
            if e.message.include?('Duplicate entry')
                raise "Student with this unique value already exists - #{e.message}"
            else
                raise e
            end
        end
    end

    def replace_student(id, new_student)
        query = <<-SQL
            UPDATE student
            SET first_name = ?, name = ?, patronymic = ?, birthdate = ?, telegram = ?, email = ?, phone_number = ?, git = ?
            WHERE id = ?
        SQL
        begin
            DB_client.instance.query(query, [
                new_student.first_name,
                new_student.name,
                new_student.patronymic,
                new_student.birthdate,
                new_student.telegram,
                new_student.email,
                new_student.phone_number,
                new_student.git,
                id
            ])
        rescue Mysql2::Error => e
            if e.message.include?('Duplicate entry')
                raise "Error: Student with this unique value already exists - #{e.message}"
            else
                raise e
            end
        end
    end

    def delete_student(id)
        query = "DELETE FROM student WHERE id = ?"
        DB_client.instance.query(query, [id])
    end

    def get_student_short_count
        result = DB_client.instance.query("SELECT COUNT(*) AS count FROM student")
        result.first['count']
    end
end