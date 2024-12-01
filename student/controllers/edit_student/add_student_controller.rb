require './models/student/student.rb'
require 'date'
require './controllers/edit_student/edit_student_controller'
require './models/student/student.rb'

class Add_student_controller < Edit_student_controller
  def operation(student_data)
    begin
      self.logger.debug "Создание объекта студента: #{student_data.to_s}"
      new_student(student_data)
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

  def valid_data?(student_data)
    self.logger.debug "Проверка валидности данных: #{student_data.to_s}"
    res = super(student_data)
    self.logger.info "Валидность данных: #{res}"
    res
  end
end