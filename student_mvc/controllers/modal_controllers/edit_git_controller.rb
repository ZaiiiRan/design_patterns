require './models/student/student.rb'
require 'date'
require_relative './edit_student_controller.rb'
require './models/student/student.rb'

class Edit_git_controller < Edit_student_controller
  def populate_fields
    self.get_student
    self.view.fields["git"].text = self.student.git
  end

  def valid_data?(data)
    data = data.transform_values { |value| value.strip }
    self.logger.debug "Проверка валидности данных: #{data.to_s}"
    res = Student.valid_git?(data["git"]) && self.student.git != data["git"]
    self.logger.info "Валидность данных: #{res}"
    res
  end
end