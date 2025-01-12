require_relative './room_list_view.rb'
require_relative '../../controllers/base_controllers/room_list_controller.rb'
require_relative './guest_list_view.rb'
require_relative '../../controllers/base_controllers/guest_list_controller.rb'

class Base_view_factory
  def self.create_view(parent, type)
    view = nil
    controller = nil
    case type
    when :room_list
      view = Room_list_view.new(parent)
      controller = Room_list_controller.new(view)
    when :guest_list
      view = Guest_list_view.new(parent)
      controller = Guest_list_controller.new(view)
    end 
    view.controller = controller
    view.setup_ui
    view.refresh_data
    view
  end
end