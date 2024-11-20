class Add_student_controller
  def initialize(view, parent_controller)
    self.view = view
    self.parent_controller = parent_controller
  end

  def add_student(student_data)
    self.parent_controller.refresh_data
    self.view.close
  end

  private
  attr_accessor :view, :parent_controller
end