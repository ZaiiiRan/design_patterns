class Edit_student_controller
  
  def initialize(view, parent_controller)
    self.view = view
    self.parent_controller = parent_controller
  end

  def save_student(student_data)
    begin
      new_student(student_data)
      self.parent_controller.replace_student(self.student)
      self.view.close
    rescue => e
      self.view.show_error_message("Ошибка при изменении студента: #{e.message}")
    end
  end

  def new_student(student_data)
    data = student_data.transform_values do |value|
      stripped = value.strip
      stripped.empty? ? nil : stripped
    end
    id = self.student.id unless self.student.nil?
    self.student = Student.new(id: id, first_name: data["first_name"],
      name: data["name"], patronymic: data["patronymic"],
      birthdate: data["birthdate"], git: data["git"], telegram: data["telegram"],
      email: data["email"], phone_number: data["phone_number"])
  end

  def get_student
    id = self.parent_controller.get_selected[0]
    begin
      self.student = self.parent_controller.get_student(id)
    rescue => e
      self.view.show_error_message("Ошибка при загрузке данных о студенте: #{e.message}")
    end
  end

  def populate_fields
    self.get_student
    self.view.fields["first_name"].text = self.student.first_name
    self.view.fields["name"].text = self.student.name
    self.view.fields["patronymic"].text = self.student.patronymic
    self.view.fields["birthdate"].text = self.student.birthdate.strftime('%d.%m.%Y')
    self.view.fields["git"].text = self.student.git
    self.view.fields["telegram"].text = self.student.telegram
    self.view.fields["email"].text = self.student.email
    self.view.fields["phone_number"].text = self.student.phone_number
  end

  def valid_data?(student_data)
    data = student_data.transform_values { |value| value.strip }
    Student.valid_name?(data["first_name"]) && Student.valid_name?(data["name"]) &&
      Student.valid_name?(data["patronymic"]) && Student.valid_birthdate?(data["birthdate"]) &&
      Student.valid_phone_number?(data["phone_number"]) && Student.valid_email?(data["email"]) &&
      Student.valid_telegram?(data["telegram"]) && Student.valid_git?(data["git"])
  end

  protected
  attr_accessor :view, :parent_controller, :student
end