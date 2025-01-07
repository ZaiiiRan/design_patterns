require_relative './base_view.rb'

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
    
  end

  def on_edit
    
  end
end