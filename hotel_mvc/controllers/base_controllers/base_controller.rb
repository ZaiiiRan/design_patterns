require_relative '../../models/filter/filter.rb'
require_relative '../../models/filter/field_filter_number.rb'
require_relative '../../models/filter/field_filter_string.rb'
require_relative '../../models/filter/has_not_field_filter.rb'
require_relative '../../models/filter/field_filter_range_number.rb'
require_relative '../../models/filter/field_filter_range_date.rb'
class Base_controller
  def initialize(view)
    self.view = view
    self.filters = Filter.new
    self.sort_order = {
      order: :asc,
      col_index: 0
    }
  end

  def refresh_data
    raise NotImplementedError
  end

  def on_add(entity)
    raise NotImplementedError
  end

  def on_edit
    raise NotImplementedError
  end

  def on_delete
    raise NotImplementedError
  end

  def get_entity
    raise NotImplementedError
  end

  def select(number)
    begin
      self.data_list.select(number)
    rescue
    end
    self.view.update_button_states
  end

  def deselect(number)
    begin
      self.data_list.deselect(number)
    rescue
    end
    self.view.update_button_states
  end

  def get_selected
    self.data_list.get_selected
  end

  def switch_page(direction)
    new_page = self.view.current_page + direction
    if new_page < 1 || new_page > self.view.total_pages
      return
    end
    self.view.current_page = new_page
    self.refresh_data
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

  def reset_filters
    self.filters = Filter.new
  end

  protected
  attr_accessor :view, :data_list, :entities_list, :sort_order, :filters

  def check_and_update_page
    if self.view.current_page > self.view.total_pages
      switch_page(-1)
    end
  end

  def apply_sort
    raise NotImplementedError
  end

  def apply_not_combo_filter(label, field, type = :string)
    value = self.view.filters[label][:text_field].text.strip
    case type
    when :string
      self.filters = Field_filter_string.new(self.filters, field, value)
    when :number
      self.filters = Field_filter_number.new(self.filters, field, value) unless value.nil? || value.empty?
    end
  end

  def apply_range_filter(label, field, type)
    filter_config = self.view.filters[label]
    value1 = filter_config[:text_field1].text.strip
    value2 = filter_config[:text_field2].text.strip
    value1 = nil if value1.empty?
    value2 = nil if value2.empty?

    case type
    when :number
      self.filters = Field_filter_range_number.new(self.filters, field, value1, value2) unless value1.nil? && value2.nil?
    when :date
      self.filters = Field_filter_range_date.new(self.filters, field, value1, value2) unless value1.nil? && value2.nil?
    end

  end

  def apply_combo_filter(label, field, type = :string)
    flag = self.view.filters[label][:combo].currentItem

    case flag
    when 0
      return
    when 1
      self.filters = Has_not_field_filter.new(self.filters, field)
    when 2
      self.apply_not_combo_filter(label, field, type)
    end
  end
end