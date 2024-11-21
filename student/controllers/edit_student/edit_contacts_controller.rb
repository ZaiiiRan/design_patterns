require './models/student/student.rb'
require 'date'
require './controllers/edit_student/edit_student_controller'
require './models/student/student.rb'

class Edit_contacts_controller < Edit_student_controller
  def populate_fields
    super
    %w(telegram email phone_number).each do |field|
      self.view.fields[field].enabled = true
    end
  end

  def valid_data?(student_data)
    data = student_data.transform_values { |value| value.strip }
    valid = super(data)
    unchanged = self.student.telegram == data["telegram"] &&
      self.student.email == data["email"] &&
      self.student.phone_number == data["phone_number"]
    valid && !unchanged
  end
end