require './models/student/student.rb'
require 'date'
require './controllers/edit_student_controller'
require './models/student/student.rb'

class Add_student_controller < Edit_student_controller
  def save_student(student_data)
    begin
      self.student = new_student(student_data)
      self.parent_controller.add_student(self.student)
      self.view.close
    rescue => e
      self.view.show_error_message("Ошибка при добавлении студента: #{e.message}")
    end
  end

  def populate_fields
    self.view.fields.each_key do |key|
      self.view.fields[key].text = ""
    end
    %w(name first_name patronymic birthdate).each do |field|
      self.view.fields[field].enabled = true
    end
  end
end