class Guests_list_interface
  def get_guest_by_id(id)
    raise NotImplementedError
  end

  def get_guests(k, n, filter = nil, data_list = nil)
    raise NotImplementedError
  end

  def add_guest(guest)
    raise NotImplementedError
  end

  def update_guest(id, guest)
    raise NotImplementedError
  end

  def delete_guest(id)
    raise NotImplementedError
  end

  def count(filter = nil)
    raise NotImplementedError
  end
end