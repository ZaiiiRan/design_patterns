require './models/student/student.rb'
require 'date'
require './controllers/edit_student_controller'
require './models/student/student.rb'

class Add_student_controller < Edit_student_controller
  def save_student(student_data)
    begin
      student = create_student(student_data)
      self.parent_controller.add_student(student)
      self.view.close
    rescue => e
      self.view.show_error_message("Ошибка при добавлении студента: #{e.message}")
    end
  end

  def create_student(student_data)
    data = student_data.transform_values { |value| value.strip }
    Student.new(name: data["name"], first_name: data["first_name"], 
      patronymic: data["patronymic"], birthdate: Date.parse(data["birthdate"]))
  end

  def populate_fields
    self.view.fields.each_key do |key|
      self.view.fields[key].text = ""
      self.view.fields[key].enabled = true
    end
  end
end