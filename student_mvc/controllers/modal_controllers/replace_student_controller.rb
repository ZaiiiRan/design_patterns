require './models/student/student.rb'
require 'date'
require_relative './edit_student_controller.rb'
require './models/student/student.rb'

class Replace_student_controller < Edit_student_controller
  def populate_fields
    self.get_student
    self.view.fields["first_name"].text = self.student.first_name
    self.view.fields["name"].text = self.student.name
    self.view.fields["patronymic"].text = self.student.patronymic
    self.view.fields["birthdate"].text = self.student.birthdate.strftime('%d.%m.%Y')
  end

  def valid_data?(data)
    data = data.transform_values { |value| value.strip }
    self.logger.debug "Проверка валидности данных: #{data.to_s}"
    valid = super(data)
    unchanged = self.student.first_name == data["first_name"] &&
      self.student.name == data["name"] &&
      self.student.patronymic == data["patronymic"] &&
      self.student.birthdate.strftime('%d.%m.%Y') == data["birthdate"]
    res = valid && !unchanged
    self.logger.info "Валидность данных: #{res}"
    res
  end
end