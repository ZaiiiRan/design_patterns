class Rooms_list_interface
  def get_room_by_id(id)
    raise NotImplementedError
  end

  def get_rooms(k, n, filter = nil, data_list = nil)
    raise NotImplementedError
  end

  def add_room(room)
    raise NotImplementedError
  end

  def delete_room(id)
    raise NotImplementedError
  end

  def update_room(id, new_room)
    raise NotImplementedError
  end

  def count(filter = nil)
    raise NotImplementedError
  end
end