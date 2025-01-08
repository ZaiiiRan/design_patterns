require_relative './modal_room_controller.rb'
require_relative '../../../models/room/room.rb'

class Add_room_controller < Modal_room_controller
  def on_ok(data)
    begin
      self.new_entity(data)
      self.parent_controller.on_add(self.entity)
      self.view.close
    rescue => e
      self.view.show_error_message("Ошибка при добавлении комнаты: #{e.message}")
    end
  end

  def populate_fields
    self.view.fields.each_key do |key|
      self.view.fields[key].text = ""
    end
  end
end