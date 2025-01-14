require_relative './base_view.rb'
require_relative '../modal/modal_factory.rb'

class Guest_list_view < Base_view
  def initialize(parent)
    super(parent, opts: LAYOUT_FILL)
  end

  def setup_ui
    table_area = self.setup_table_area(7)
    self.setup_pagination_area(table_area)
    super
  end

  private
  def on_add
    modal_view = Modal_factory.create_modal(self, self.controller, :add_guest)
    modal_view.create
    modal_view.show(PLACEMENT_OWNER)
  end

  def on_edit
    modal_view = Modal_factory.create_modal(self, self.controller, :edit_guest)
    modal_view.create
    modal_view.show(PLACEMENT_OWNER)
  end
end