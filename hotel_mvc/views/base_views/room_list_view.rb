require_relative './base_view.rb'
require_relative '../modal/modal_factory.rb'

class Room_list_view < Base_view
  def initialize(parent)
    super(parent, opts: LAYOUT_FILL)
  end

  def setup_ui
    table_area = self.setup_table_area(4)
    self.setup_pagination_area(table_area)
    self.current_page = 1
    self.total_pages = 1
    self.setup_controls_area
  end

  private
  def on_add
    modal_view = Modal_factory.create_modal(self, self.controller, :add_room)
    modal_view.create
    modal_view.show(PLACEMENT_OWNER)
  end

  def on_edit
    modal_view = Modal_factory.create_modal(self, self.controller, :edit_room)
    modal_view.create
    modal_view.show(PLACEMENT_OWNER)
  end
end