class Labs_list_interface
  def get_lab_by_id(id)
    raise NotImplementedError
  end

  def get_labs(data_list = nil)
    raise NotImplementedError
  end

  def add_lab(lab)
    raise NotImplementedError
  end

  def replace_lab(id, new_lab)
    raise NotImplementedError
  end

  def delete_lab(id)
    raise NotImplementedError
  end
end