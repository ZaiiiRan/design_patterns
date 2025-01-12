require 'fox16'
require './views/base_views/base_view_factory.rb'

include Fox

class App < FXMainWindow
  def initialize(app)
    super(app, 'Отель', width: 1024, height: 768)
    self.create_tabs
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end

  private
  attr_accessor :room_list_view, :guest_list_view

  def on_tab_changed(index)
    if index == 0
      self.room_list_view.refresh_data
    elsif index == 1
      self.guest_list_view.refresh_data
    end
  end

  def create_tabs
    tabs = FXTabBook.new(self, opts: LAYOUT_FILL)

    FXTabItem.new(tabs, 'Комнаты', opts: JUSTIFY_CENTER_X)
    room_list = FXVerticalFrame.new(tabs, opts: LAYOUT_FILL)
    self.room_list_view = Base_view_factory.create_view(room_list, :room_list)

    FXTabItem.new(tabs, 'Гости', opts: JUSTIFY_CENTER_X)
    guest_list = FXVerticalFrame.new(tabs, opts: LAYOUT_FILL)
    self.guest_list_view = Base_view_factory.create_view(guest_list, :guest_list)

    FXTabItem.new(tabs, 'Бронь', opts: JUSTIFY_CENTER_X)
    booking_list = FXVerticalFrame.new(tabs, opts: LAYOUT_FILL)

    FXVerticalFrame.new(tabs, opts: LAYOUT_FILL)

    tabs.connect(SEL_COMMAND) do |sender, _selector, index|
      self.on_tab_changed(index)
    end
  end
end