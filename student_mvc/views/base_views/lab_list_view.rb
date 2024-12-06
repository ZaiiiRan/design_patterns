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
    modal_view = Modal_factory.create_modal(self, self.controller, :add_lab)
    modal_view.create
    modal_view.show(PLACEMENT_OWNER)
  end

  def on_edit
    modal_view = Modal_factory.create_modal(self, self.controller, :replace_lab)
    modal_view.create
    modal_view.show(PLACEMENT_OWNER)
  end
end