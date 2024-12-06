require_relative '../modal_controller'

class Edit_student_controller < Modal_controller
  # constructor
  def initialize(view, parent_controller)
    super(view, parent_controller)
  end

  # do operation
  def operation(data)
    begin
      self.logger.debug "Создание объекта студента: #{data.to_s}"
      new_entity(data)
      self.parent_controller.on_edit(self.entity)
      self.view.close
    rescue => e
      error_msg = "Ошибка при изменении студента: #{e.message}"
      self.logger.error error_msg
      self.view.show_error_message(error_msg)
    end
  end

  # new student object
  def new_entity(data)
    data = data.transform_values do |value|
      stripped = value.strip
      stripped.empty? ? nil : stripped
    end

    attributes = self.get_attributes
    data.each do |key, value|
      attributes[key.to_sym] = value
    end
    self.entity = Student.new_from_hash(attributes)
  end

  # get student object
  def get_entity
    id = self.parent_controller.get_selected[0]
    begin
      self.entity = self.parent_controller.get_student(id)
    rescue => e
      error_msg = "Ошибка при загрузке данных о студенте: #{e.message}"
      self.logger.error error_msg
      self.view.show_error_message(error_msg)
    end
  end

  # valid data?
  def valid_data?(data)
    data = data.transform_values { |value| value.strip }
    Student.valid_name?(data["first_name"]) && Student.valid_name?(data["name"]) &&
      Student.valid_name?(data["patronymic"]) && Student.valid_birthdate?(data["birthdate"])
  end

  protected

  # get attributes
  def get_attributes
    {
      id: self.entity&.id,
      first_name: self.entity&.first_name,
      name: self.entity&.name,
      patronymic: self.entity&.patronymic,
      birthdate: self.entity&.birthdate,
      git: self.entity&.git,
      telegram: self.entity&.telegram,
      email: self.entity&.email,
      phone_number: self.entity&.phone_number
    }
  end
end