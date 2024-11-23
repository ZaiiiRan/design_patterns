require './models/students_list/students_list'
require './models/students_list/students_list_DB'
require './models/data_list/data_list_student_short'
require './models/students_list/students_list_file_adapter'
require './models/students_list/students_list_file'
require './models/data_storage_strategy/JSON_storage_strategy'
require 'mysql2'
require './models/student/student.rb'
require './controllers/base_controllers/base_controller.rb'
require './models/filter/filter.rb'
require './models/filter/student_filters/field_filter_decorator.rb'
require './models/filter/student_filters/full_name_filter_decorator.rb'
require './models/filter/student_filters/has_not_field_filter_decorator.rb'
require './models/filter/student_filters/contact_sort_decorator.rb'
require './models/filter/student_filters/git_sort_decorator.rb'
require './models/filter/student_filters/full_name_sort_decorator.rb'

class Student_list_controller < Base_controller
  def initialize(view)
    super(view)
    begin
      self.entities_list = Students_list.new(Students_list_DB.new)
      # self.entities_list = Students_list.new(Students_list_file_adapter.new(Students_list_file.new('./students.json', JSON_storage_strategy.new)))
      self.data_list = Data_list_student_short.new([])
      self.data_list.add_observer(self.view)
      self.filters = Filter.new
      self.sort_order = {
        order: :asc,
        col_index: 0
      }
    rescue StandardError => e
      self.view.show_error_message("Ошибка при получении доступа к файлу: #{e.message}")
    end
  end

  def refresh_data
    self.data_list.clear_selected
    self.reset_filters
    self.apply_filters
    begin
      self.data_list = self.entities_list.get_k_n_student_short_list(self.view.current_page, self.view.class::ROWS_PER_PAGE, self.filters, self.data_list)
      self.data_list.count = self.entities_list.get_student_short_count
      data_list.notify
      self.view.update_button_states
    rescue => e
      self.view.show_error_message("Ошибка при получении данных: #{e.message}")
    end
  end

  def add_student(student)
    self.entities_list.add_student(student)
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
    self.entities_list.get_student_by_id(id)
  end

  def replace_student(student)
    self.entities_list.replace_student(student.id, student)
    self.refresh_data
  end

  def delete_student
    ids = self.get_selected
    begin
      ids.each do |id|
        self.entities_list.delete_student(id)
      end
    rescue => e
      self.view.show_error_message("Ошибка при удалении: #{e.message}")
    ensure
      self.refresh_data
      self.check_and_update_page
    end
  end

  def check_and_update_page()
    if self.view.current_page > self.view.total_pages
      switch_page(-1)
    end
  end

  def switch_page(direction)
    new_page = self.view.current_page + direction
    if new_page < 1 || new_page > self.view.total_pages
      return
    end
    self.view.current_page = new_page
    self.refresh_data
  end

  def apply_filters
    self.apply_full_name_filter
    self.apply_git_filter
    self.apply_email_filter
    self.apply_phone_number_filter
    self.apply_telegram_filter
    self.apply_sort
  end

  def reset_filters
    self.filters = Filter.new
  end

  def set_sort_order(column_index)
    if self.sort_order[:col_index] == column_index
      self.sort_order[:order] = self.sort_order[:order] == :asc ? :desc : :asc 
    else
      self.sort_order[:col_index] = column_index
      self.sort_order[:order] = :asc
    end
    self.refresh_data
  end

  private
  attr_accessor :filters, :sort_order

  def apply_full_name_filter
    name = self.view.filters['name'][:text_field].text
    self.filters = Full_name_filter_decorator.new(self.filters, self.view.filters['name'][:text_field].text) unless name.nil? || name.empty?
  end

  def apply_field_filter(field_key, filter_field, filter_type = :text_field)
    filter_config = self.view.filters[field_key]
    flag = filter_config[:combo].currentItem
    text = filter_config[filter_type].text.strip if filter_type == :text_field
  
    case flag
    when 0
      return
    when 1
      self.filters = Field_filter_decorator.new(self.filters, filter_field, text) unless text.nil? || text.empty?
    when 2
      self.filters = Has_not_field_filter_decorator.new(self.filters, filter_field)
    end
  end

  def apply_git_filter
    apply_field_filter('Git:', 'git')
  end
  
  def apply_email_filter
    apply_field_filter('Email:', 'email')
  end
  
  def apply_phone_number_filter
    apply_field_filter('Телефон:', 'phone_number')
  end
  
  def apply_telegram_filter
    apply_field_filter('Telegram:', 'telegram')
  end

  def apply_sort
    case self.sort_order[:col_index]
    when 1
      self.filters = Full_name_sort_decorator.new(self.filters, self.sort_order[:order])
    when 2
      self.filters = Git_sort_decorator.new(self.filters, self.sort_order[:order])
    when 3
      self.filters = Contact_sort_decorator.new(self.filters, self.sort_order[:order])
    else
      self.filters
    end
  end
end