require './models/student/student.rb'
require 'date'
require './controllers/edit_student_controller'

class Add_student_controller < Edit_student_controller
  def save_student(student_data)
    begin
      self.parent_controller.add_student(student_data)
      self.view.close
    rescue => e
      self.view.show_error_message("Ошибка при добавлении студента: #{e.message}")
    end
  end

  def get_student
    self.view.student_id = nil
  end

  def populate_fields
    self.view.fields.each_key do |key|
      self.view.fields[key].text = ""
      self.view.fields[key].enabled = true
    end
  end
end