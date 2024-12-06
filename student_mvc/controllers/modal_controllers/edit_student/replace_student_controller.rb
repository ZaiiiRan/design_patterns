require './models/student/student.rb'
require 'date'
require_relative './edit_student_controller.rb'
require './models/student/student.rb'

class Replace_student_controller < Edit_student_controller
  # populate fields
  def populate_fields
    self.get_entity
    self.view.fields["first_name"].text = self.entity.first_name
    self.view.fields["name"].text = self.entity.name
    self.view.fields["patronymic"].text = self.entity.patronymic
    self.view.fields["birthdate"].text = self.entity.birthdate.strftime('%d.%m.%Y')
  end

  # valid data?
  def valid_data?(data)
    data = data.transform_values { |value| value.strip }
    self.logger.debug "Проверка валидности данных: #{data.to_s}"
    valid = super(data)
    unchanged = self.entity.first_name == data["first_name"] &&
      self.entity.name == data["name"] &&
      self.entity.patronymic == data["patronymic"] &&
      self.entity.birthdate.strftime('%d.%m.%Y') == data["birthdate"]
    res = valid && !unchanged
    self.logger.info "Валидность данных: #{res}"
    res
  end
end