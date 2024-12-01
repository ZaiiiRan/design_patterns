require './models/student/student.rb'
require 'date'
require './controllers/edit_student/edit_student_controller'
require './models/student/student.rb'

class Edit_contacts_controller < Edit_student_controller
  def populate_fields
    self.get_student
    self.view.fields["telegram"].text = self.student.telegram
    self.view.fields["email"].text = self.student.email
    self.view.fields["phone_number"].text = self.student.phone_number
  end

  def valid_data?(student_data)
    data = student_data.transform_values { |value| value.strip }
    self.logger.debug "Проверка валидности данных: #{data.to_s}"
    valid = Student.valid_phone_number?(data["phone_number"]) && Student.valid_email?(data["email"]) &&
      Student.valid_telegram?(data["telegram"])
    unchanged = self.student.telegram == data["telegram"] &&
      self.student.email == data["email"] &&
      self.student.phone_number == data["phone_number"]
    res = valid && !unchanged
    self.logger.info "Валидность данных: #{res}"
    res
  end
end