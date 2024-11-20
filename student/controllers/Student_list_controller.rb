require './models/students_list/students_list'
require './models/students_list/students_list_DB_adapter'
require './models/data_list/data_list_student_short'
require './models/students_list/students_list_file_adapter'
require './models/data_storage_strategy/JSON_storage_strategy'
require 'mysql2'
require './models/student/student.rb'

class Student_list_controller
  def initialize(view)
    self.view = view
    begin
      self.student_list = Students_list.new(Students_list_DB_adapter.new)
      # self.student_list = Students_list.new(Students_list_file_adapter.new('./students.json', JSON_storage_strategy.new))
      self.data_list = Data_list_student_short.new([])
      self.data_list.add_observer(self.view)
    rescue StandardError => e
      self.view.show_error_message("Ошибка при получении доступа к файлу: #{e.message}")
    end
  end

  def refresh_data
    self.data_list.clear_selected unless self.data_list.nil?
    begin
      self.data_list = self.student_list.get_k_n_student_short_list(self.view.current_page, self.view.class::ROWS_PER_PAGE, nil, self.data_list)
      self.data_list.count = self.student_list.get_student_short_count
      self.data_list.select_all
      data_list.notify
    rescue => e
      self.view.show_error_message("Ошибка при получении данных: #{e.message}")
    end
  end

  def add_student(student_data)
    student = Student.new(first_name: student_data["first_name"], name: student_data["name"], patronymic: student_data["patronymic"],
      birthdate: student_data["birthdate"])
    self.student_list.add_student(student)
    self.refresh_data
  end

  def replace_student
  end

  def delete_student
  end

  def update
  end

  private
  attr_accessor :view, :student_list, :data_list
end