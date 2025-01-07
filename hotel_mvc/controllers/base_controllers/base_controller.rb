class Base_controller
  def initialize(view)
    self.view = view
  end

  def refresh_data
    raise NotImplementedError
  end

  def on_add
    raise NotImplementedError
  end

  def on_edit
    raise NotImplementedError
  end

  def on_delete
    raise NotImplementedError
  end

  def get_entity
    raise NotImplementedError
  end

  def select(number)
    begin
      self.data_list.select(number)
    rescue
    end
  end

  def deselect(number)
    begin
      self.data_list.deselect(number)
    rescue
    end
  end

  def get_selected
    self.data_list.get_selected
  end

  def switch_page(direction)
    new_page = self.view.current_page + direction
    if new_page < 1 || new_page > self.view.total_pages
      return
    end
    self.view.current_page = new_page
    self.refresh_data
  end

  protected
  attr_accessor :view, :data_list, :entities_list
end