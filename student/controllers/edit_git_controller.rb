require './models/student/student.rb'
require 'date'
require './controllers/edit_student_controller'
require './models/student/student.rb'

class Edit_git_controller < Edit_student_controller
  def populate_fields
    super
    self.view.fields["git"].enabled = true
  end

  def valid_data?(student_data)
    data = student_data.transform_values { |value| value.strip }
    super(data) && self.student.git != data["git"]
  end
end