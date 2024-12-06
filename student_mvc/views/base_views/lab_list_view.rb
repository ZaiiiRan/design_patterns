require 'fox16'
require_relative '../../models/data_list/data_list_lab'
require_relative '../../models/lab/lab'
require_relative './base_view'
require_relative '../modal/modal_factory'

include Fox

class Lab_list_view < Base_view
  def initialize(parent)
    super(parent, opts: LAYOUT_FILL)
    self.rows_per_page = 16
  end

  def setup_ui
    setup_table_area(5)
    setup_control_buttons_area
    refresh_data
  end

  private
  def on_add
    
  end

  def on_edit
    
  end
end