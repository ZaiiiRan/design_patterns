require './logger/logger.rb'

class Edit_student_controller
  
  def initialize(view, parent_controller)
    self.view = view
    self.parent_controller = parent_controller
    self.logger = App_logger.instance
  end

  def operation(student_data)
    begin
      self.logger.debug "Создание объекта студента: #{student_data.to_s}"
      new_student(student_data)
      self.parent_controller.replace_student(self.student)
      self.view.close
    rescue => e
      error_msg = "Ошибка при изменении студента: #{e.message}"
      self.logger.error error_msg
      self.view.show_error_message(error_msg)
    end
  end

  def new_student(student_data)
    data = student_data.transform_values do |value|
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

  def populate_fields
    raise NotImplementedError
  end

  def valid_data?(student_data)
    data = student_data.transform_values { |value| value.strip }
    Student.valid_name?(data["first_name"]) && Student.valid_name?(data["name"]) &&
      Student.valid_name?(data["patronymic"]) && Student.valid_birthdate?(data["birthdate"])
  end

  protected
  attr_accessor :view, :parent_controller, :student, :logger

  private
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