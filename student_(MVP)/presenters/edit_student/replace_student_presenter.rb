require './models/student/student.rb'
require 'date'
require './presenters/edit_student/edit_student_presenter'
require './models/student/student.rb'

class Replace_student_presenter < Edit_student_presenter
  def populate_fields
    self.get_student
    data = {
      "first_name" => self.student.first_name,
      "name" => self.student.name,
      "patronymic" => self.student.patronymic,
      "birthdate" => self.student.birthdate.strftime('%d.%m.%Y'),
    }
    self.view.update_view data
  end

  def valid_data?(student_data)
    data = student_data.transform_values { |value| value.strip }
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