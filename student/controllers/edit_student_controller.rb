class Edit_student_controller
  
  def initialize(view, parent_controller)
    self.view = view
    self.parent_controller = parent_controller
  end

  def save_student
    raise NotImplementedError
  end

  def populate_fields
    raise NotImplementedError
  end

  def valid_data?(student_data)
    data = student_data.transform_values { |value| value.strip }
    Student.valid_name?(data["first_name"]) && Student.valid_name?(data["name"]) &&
      Student.valid_name?(data["patronymic"]) && Student.valid_birthdate?(data["birthdate"])
  end

  protected
  attr_accessor :view, :parent_controller
end