require './models/students_list/students_list'
require './models/students_list/students_list_DB_adapter'
require './models/data_list/data_list_student_short'
require './models/students_list/students_list_file_adapter'
require './models/data_storage_strategy/JSON_storage_strategy'
require 'mysql2'
require './models/student/student.rb'
require './controllers/base_controllers/base_controller.rb'

class Student_list_controller < Base_controller
  def initialize(view)
    super(view)
    begin
      self.list = Students_list.new(Students_list_DB_adapter.new)
      # self.student_list = Students_list.new(Students_list_file_adapter.new('./students.json', JSON_storage_strategy.new))
      self.data_list = Data_list_student_short.new([])
      self.data_list.add_observer(self.view)
    rescue StandardError => e
      self.view.show_error_message("Ошибка при получении доступа к файлу: #{e.message}")
    end
  end

  def refresh_data
    self.data_list.clear_selected
    begin
      self.data_list = self.list.get_k_n_student_short_list(self.view.current_page, self.view.class::ROWS_PER_PAGE, nil, self.data_list)
      self.data_list.count = self.list.get_student_short_count
      data_list.notify
      self.view.update_button_states
    rescue => e
      self.view.show_error_message("Ошибка при получении данных: #{e.message}")
    end
  end

  def add_student(student)
    self.list.add_student(student)
    self.refresh_data
  end

  def select(number)
    begin
      self.data_list.select(number)
      self.view.update_button_states
    rescue
    end
  end

  def deselect(number)
    begin
      self.data_list.deselect(number)
      self.view.update_button_states
    rescue
    end
  end

  def get_selected
    self.data_list.get_selected
  end

  def get_student(id)
    self.list.get_student_by_id(id)
  end

  def replace_student(student)
    self.list.replace_student(student.id, student)
    self.refresh_data
  end

  def delete_student
  end

  def update
  end
end