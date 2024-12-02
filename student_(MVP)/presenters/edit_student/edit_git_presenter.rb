require './models/student/student.rb'
require 'date'
require './presenters/edit_student/edit_student_presenter'
require './models/student/student.rb'

class Edit_git_presenter < Edit_student_presenter
  def populate_fields
    self.get_student
    data = {
      "git" => self.student.git,
    }
    self.view.update_view data
  end

  def valid_data?(student_data)
    data = student_data.transform_values { |value| value.strip }
    self.logger.debug "Проверка валидности данных: #{data.to_s}"
    res = Student.valid_git?(data["git"]) && self.student.git != data["git"]
    self.logger.info "Валидность данных: #{res}"
    res
  end
end