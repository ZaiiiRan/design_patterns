require './models/student/student.rb'
require 'date'
require './controllers/edit_student/edit_student_controller'
require './models/student/student.rb'

class Replace_student_controller < Edit_student_controller
  def populate_fields
    self.get_student
    self.view.fields["first_name"].text = self.student.first_name
    self.view.fields["name"].text = self.student.name
    self.view.fields["patronymic"].text = self.student.patronymic
    self.view.fields["birthdate"].text = self.student.birthdate.strftime('%d.%m.%Y')
  end

  def valid_data?(student_data)
    data = student_data.transform_values { |value| value.strip }
    valid = super(data)
    unchanged = self.student.first_name == data["first_name"] &&
      self.student.name == data["name"] &&
      self.student.patronymic == data["patronymic"] &&
      self.student.birthdate.strftime('%d.%m.%Y') == data["birthdate"]
    valid && !unchanged
  end
end