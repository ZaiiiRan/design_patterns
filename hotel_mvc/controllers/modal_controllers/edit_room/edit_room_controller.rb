require_relative './modal_room_controller.rb'
require_relative '../../../models/room/room.rb'

class Edit_room_controller < Modal_room_controller
  def populate_fields
    self.get_entity
    self.view.fields[:number].text = self.entity.number.to_s
    self.view.fields[:capacity].text = self.entity.capacity.to_s
    self.view.fields[:price].text = self.entity.price.to_s
  end

  def valid_data?(data)
    data = data.transform_values { |value| value.strip }
    valid = super(data)
    unchanged = self.entity.number.to_s == data[:number] && self.entity.capacity.to_s == data[:capacity] && self.entity.price.to_s == data[:price]
    valid && !unchanged
  end
end