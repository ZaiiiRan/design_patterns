require_relative '../modal_controller.rb'
require_relative '../../../models/room/room.rb'

class Modal_room_controller < Modal_controller
  def initialize(view, parent_controller)
    super(view, parent_controller)
  end

  def on_ok(data)
    begin
      self.new_entity(data)
      self.parent_controller.on_edit(self.entity)
      self.view.close
    rescue => e
      self.view.show_error_message("Ошибка при изменении данных комнаты: #{e.message}")
    end
  end

  def new_entity(data)
    data = data.transform_values do |value|
      stripped = value.strip
      stripped.empty? ? nil : stripped.to_i
    end

    attributes = self.get_attributes
    data.each do |key, value|
      attributes[key.to_sym] = value
    end
    self.entity = Room.new_from_hash(attributes)
  end

  def get_entity
    id = self.parent_controller.get_selected[0]
    begin
      self.entity = self.parent_controller.get_entity(id)
    rescue => e
      self.view.show_error_message("Ошибка при загрузке данных о комнате: #{e.message}")
    end
  end

  def valid_data?(data)
    data = data.transform_values { |value| value.strip }
    !data[:number].empty? && Room.valid_number?(data[:number].to_i) && !data[:capacity].empty? && Room.valid_capacity?(data[:capacity].to_i) && 
      !data[:price].empty? && Room.valid_price?(data[:price].to_i)
  end

  protected

  def get_attributes
    {
      id: self.entity&.id,
      number: self.entity&.number,
      capacity: self.entity&.capacity,
      price: self.entity&.price
    }
  end
end