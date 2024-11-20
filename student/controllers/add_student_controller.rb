require './models/student/student.rb'
require 'date'

class Add_student_controller
  def initialize(view, parent_controller)
    self.view = view
    self.parent_controller = parent_controller
  end

  def add_student(student_data)
    begin
      self.parent_controller.add_student(student_data)
    rescue => e
      self.view.show_error_message("Ошибка при добавлении студента: #{e.message}")
    end
    self.parent_controller.refresh_data
    self.view.close
  end

  def valid_data?(student_data)
    Student.valid_name?(student_data["first_name"].strip) && Student.valid_name?(student_data["name"].strip) &&
      Student.valid_name?(student_data["patronymic"].strip) && Student.valid_birthdate?(student_data["birthdate"].strip)
  end

  private
  attr_accessor :view, :parent_controller
end