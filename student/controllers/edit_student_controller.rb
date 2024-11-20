class Edit_student_controller
  
  def initialize(view, parent_controller)
    self.view = view
    self.parent_controller = parent_controller
  end

  def save_student
    raise NotImplementedError
  end

  def get_student
    raise NotImplementedError
  end

  def populate_fields
    raise NotImplementedError
  end

  def valid_data?(student_data)
    Student.valid_name?(student_data["first_name"].strip) && Student.valid_name?(student_data["name"].strip) &&
      Student.valid_name?(student_data["patronymic"].strip) && Student.valid_birthdate?(student_data["birthdate"].strip)
  end

  protected
  attr_accessor :view, :parent_controller
end