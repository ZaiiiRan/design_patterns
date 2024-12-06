require './models/student/student.rb'
require 'date'
require_relative './edit_student_controller.rb'
require './models/student/student.rb'

class Add_student_controller < Edit_student_controller
  def operation(data)
    begin
      self.logger.debug "Создание объекта студента: #{data.to_s}"
      new_student(data)
      self.parent_controller.add_student(self.student)
      self.view.close
    rescue => e
      error_msg = "Ошибка при добавлении студента: #{e.message}"
      self.logger.error error_msg
      self.view.show_error_message(error_msg)
    end
  end

  def populate_fields
    self.view.fields.each_key do |key|
      self.view.fields[key].text = ""
    end
  end

  def valid_data?(data)
    self.logger.debug "Проверка валидности данных: #{data.to_s}"
    res = super(data)
    self.logger.info "Валидность данных: #{res}"
    res
  end
end