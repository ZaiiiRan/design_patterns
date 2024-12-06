class Labs_list
  def initialize(adapter)
    self.adapter = adapter
  end

  def get_lab_by_id(id)
    self.adapter.get_lab_by_id(id)
  end

  def get_labs(data_list = nil)
    self.adapter.get_labs(data_list)
  end

  def add_lab(lab)
    self.adapter.add_lab(lab)
  end

  def replace_lab(id, new_lab)
    self.adapter.replace_lab(id, new_lab)
  end

  def delete_lab(id)
    self.adapter.delete_lab(id)
  end

  private
  attr_accessor :adapter
end