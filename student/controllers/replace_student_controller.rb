require './models/student/student.rb'
require 'date'
require './controllers/edit_student_controller'

class Replace_student_controller < Edit_student_controller
  def save_student(student_data)
    begin
      self.parent_controller.replace_student(student_data)
      self.view.close
    rescue => e
      self.view.show_error_message("Ошибка при изменении студента: #{e.message}")
    end
  end

  def get_student
    self.view.student_id = self.parent_controller.get_selected[0]
  end

  def populate_fields
    begin
      student = self.parent_controller.get_student(self.view.student_id)
    rescue => e
      self.view.show_error_message("Ошибка при загрузке данных о студенте: #{e.message}")
    end
    self.view.fields["first_name"].text = student.first_name
    self.view.fields["name"].text = student.name
    self.view.fields["patronymic"].text = student.patronymic
    self.view.fields["birthdate"].text = student.birthdate.strftime('%d.%m.%Y')
    self.view.fields.each_key do |key|
      self.view.fields[key].enabled = true
    end
  end
end