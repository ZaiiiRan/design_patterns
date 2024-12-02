require './models/student/student.rb'
require 'date'
require './presenters/edit_student/edit_student_presenter'
require './models/student/student.rb'

class Add_student_presenter < Edit_student_presenter
  def operation(student_data)
    begin
      self.logger.debug "Создание объекта студента: #{student_data.to_s}"
      new_student(student_data)
      self.parent_presenter.add_student(self.student)
      self.view.close
    rescue => e
      error_msg = "Ошибка при добавлении студента: #{e.message}"
      self.logger.error error_msg
      self.view.show_error_message(error_msg)
    end
  end

  def populate_fields
    data = {
    "first_name" => "",
    "name" => "",
    "patronymic" => "",
    "birthdate" => "",
  }
    self.view.update_view data
  end

  def valid_data?(student_data)
    self.logger.debug "Проверка валидности данных: #{student_data.to_s}"
    res = super(student_data)
    self.logger.info "Валидность данных: #{res}"
    res
  end
end