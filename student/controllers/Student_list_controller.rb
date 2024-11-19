require './models/students_list/students_list'
require './models/students_list/students_list_DB_adapter'
require './models/data_list/data_list_student_short'
require './models/students_list/students_list_file_adapter'
require './models/data_storage_strategy/JSON_storage_strategy'

class Student_list_controller
  def initialize(view)
    self.view = view
    self.student_list = Students_list.new(Students_list_file_adapter.new('./students.json', JSON_storage_strategy.new()))
    self.data_list = Data_list_student_short.new([])
    self.data_list.add_observer(self.view)
  end

  def refresh_data
    self.data_list.clear_selected unless self.data_list.nil?
    self.data_list = self.student_list.get_k_n_student_short_list(self.view.current_page, self.view.class::ROWS_PER_PAGE, nil, self.data_list)
    self.data_list.count = self.student_list.get_student_short_count
    self.data_list.select_all
    data_list.notify
  end

  def add_student
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