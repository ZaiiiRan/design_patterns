require './models/student/student.rb'
require 'date'
require './controllers/edit_student_controller'
require './models/student/student.rb'

class Replace_student_controller < Edit_student_controller
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
    data = student_data.transform_values { |value| value.strip }
    self.student = Student.new(id: self.student.id, first_name: data["first_name"],
      name: data["name"], patronymic: data["patronymic"],
      birthdate: data["birthdate"], git: self.student.git, telegram: self.student.telegram,
      email: self.student.email, phone_number: self.student.phone_number)
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
    self.view.fields.each_key do |key|
      self.view.fields[key].enabled = true
    end
  end

  def valid_data?(student_data)
    data = student_data.transform_values { |value| value.strip }
    valid = super(data)
    unchanged = self.student.first_name == data["first_name"] &&
      self.student.name == data["name"] &&
      self.student.patronymic == data["patronymic"] &&
      self.student.birthdate.strftime('%d.%m.%Y') == data["birthdate"]
    valid && !unchanged
  end

  private
  attr_accessor :student
end