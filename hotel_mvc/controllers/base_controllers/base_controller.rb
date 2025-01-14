require_relative '../../models/filter/filter.rb'
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
end