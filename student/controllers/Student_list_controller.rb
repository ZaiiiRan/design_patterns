require './models/student_list/students_list'
require './models/student_list/students_list_DB_adapter'

class Student_list_controller
  def initialize(view)
    self.view = view
    self.student_list = Student_list.new(Students_list_DB_adapter.new)
  end

  def refresh_data
  end

  def add_student
  end

  def replace_student
  end

  def delete_student
  end

  def update
  end

  private
  attr_accessor :view, :student_list
end