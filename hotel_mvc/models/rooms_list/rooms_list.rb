class Rooms_list
  def initialize(adapter)
    self.adapter = adapter
  end

  def get_room_by_id(id)
    self.adapter.get_room_by_id(id)
  end

  def get_rooms(k, n, filter = nil, data_list = nil)
    self.adapter.get_rooms(k, n, filter, data_list)
  end

  def add_room(room)
    self.adapter.add_room(room)
  end

  def update_room(id, room)
    self.adapter.update_room(id, room)
  end

  def delete_room(id)
    self.adapter.delete_room(id)
  end

  def count(filter = nil)
    self.adapter.count(filter)
  end

  private
  attr_accessor :adapter
end