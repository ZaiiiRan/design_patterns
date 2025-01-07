require_relative './base_controller.rb'
require_relative '../../models/rooms_list/rooms_list.rb'
require_relative '../../models/rooms_list/rooms_list_db.rb'
require_relative '../../models/data_list/data_list_room.rb'

class Room_list_controller < Base_controller
  def initialize(view)
    super(view)

    self.entities_list = Rooms_list.new(Rooms_list_db.new)
    self.data_list = Data_list_room.new([])
    self.data_list.add_observer(view)
  end

  def refresh_data
    self.data_list.clear_selected
    begin
      self.data_list.count = self.entities_list.count
      self.entities_list.get_rooms(self.view.current_page, self.view.rows_per_page, nil, self.data_list)
    rescue
      self.view.show_error_message(error_msg)
    end
  end

  def on_delete
    
  end
end