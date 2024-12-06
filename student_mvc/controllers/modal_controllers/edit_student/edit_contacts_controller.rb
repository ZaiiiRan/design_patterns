require './models/student/student.rb'
require 'date'
require_relative './edit_student_controller.rb'
require './models/student/student.rb'

class Edit_contacts_controller < Edit_student_controller
  # populate fields
  def populate_fields
    self.get_entity
    self.view.fields["telegram"].text = self.entity.telegram
    self.view.fields["email"].text = self.entity.email
    self.view.fields["phone_number"].text = self.entity.phone_number
  end

  # valid data?
  def valid_data?(data)
    data = data.transform_values { |value| value.strip }
    self.logger.debug "Проверка валидности данных: #{data.to_s}"
    valid = Student.valid_phone_number?(data["phone_number"]) && Student.valid_email?(data["email"]) &&
      Student.valid_telegram?(data["telegram"])
    unchanged = (self.entity.telegram == data["telegram"] || (self.entity.telegram.nil? && data["telegram"].empty?)) &&
      (self.entity.email == data["email"] || (self.entity.email.nil? && data["email"].empty?)) &&
      (self.entity.phone_number == data["phone_number"] || (self.entity.phone_number.nil? && data["phone_number"].empty?))
    res = valid && !unchanged
    self.logger.info "Валидность данных: #{res}"
    res
  end
end