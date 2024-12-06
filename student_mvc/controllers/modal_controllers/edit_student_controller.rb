require_relative './modal_controller'

class Edit_student_controller < Modal_controller
  
  def initialize(view, parent_controller)
    super(view, parent_controller)
  end

  def operation(data)
    begin
      self.logger.debug "Создание объекта студента: #{data.to_s}"
      new_student(data)
      self.parent_controller.replace_student(self.student)
      self.view.close
    rescue => e
      error_msg = "Ошибка при изменении студента: #{e.message}"
      self.logger.error error_msg
      self.view.show_error_message(error_msg)
    end
  end

  def new_student(data)
    data = data.transform_values do |value|
      stripped = value.strip
      stripped.empty? ? nil : stripped
    end

    attributes = self.get_attributes
    data.each do |key, value|
      attributes[key.to_sym] = value
    end
    self.student = Student.new_from_hash(attributes)
  end

  def get_student
    id = self.parent_controller.get_selected[0]
    begin
      self.student = self.parent_controller.get_student(id)
    rescue => e
      error_msg = "Ошибка при загрузке данных о студенте: #{e.message}"
      self.logger.error error_msg
      self.view.show_error_message(error_msg)
    end
  end

  def valid_data?(data)
    data = data.transform_values { |value| value.strip }
    Student.valid_name?(data["first_name"]) && Student.valid_name?(data["name"]) &&
      Student.valid_name?(data["patronymic"]) && Student.valid_birthdate?(data["birthdate"])
  end

  protected
  attr_accessor :student

  def get_attributes
    {
      id: self.student&.id,
      first_name: self.student&.first_name,
      name: self.student&.name,
      patronymic: self.student&.patronymic,
      birthdate: self.student&.birthdate,
      git: self.student&.git,
      telegram: self.student&.telegram,
      email: self.student&.email,
      phone_number: self.student&.phone_number
    }
  end
end