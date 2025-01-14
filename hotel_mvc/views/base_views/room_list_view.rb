require_relative './base_view.rb'
require_relative '../modal/modal_factory.rb'

class Room_list_view < Base_view
  def initialize(parent)
    super(parent, opts: LAYOUT_FILL)
  end

  def setup_ui
    self.setup_filtering_area
    table_area = self.setup_table_area(4)
    self.setup_pagination_area(table_area)
    self.setup_controls_area
    super
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

  def setup_filtering_area
    filtering_area = FXVerticalFrame.new(self, opts: LAYOUT_FILL_X | LAYOUT_SIDE_TOP)
    FXLabel.new(filtering_area, 'Поиск')

    self.add_filtering_row(filtering_area, "Номер комнаты:")
    self.add_filtering_range_fields(filtering_area, "Максимум человек:")
    self.add_filtering_range_fields(filtering_area, "Цена за ночь:")
  end
end