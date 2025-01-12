class Guests_list
  def initialize(adapter)
    self.adapter = adapter
  end

  def get_guest_by_id(id)
    self.adapter.get_guest_by_id(id)
  end

  def get_guests(k, n, filter = nil, data_list = nil)
    self.adapter.get_guests(k, n, filter, data_list)
  end

  def add_guest(guest)
    self.adapter.add_guest(guest)
  end

  def update_guest(id, guest)
    self.adapter.update_guest(id, guest)
  end

  def delete_guest(id)
    self.adapter.delete_guest(id)
  end

  def count(filter = nil)
    self.adapter.count(filter)
  end

  private
  attr_accessor :adapter
end