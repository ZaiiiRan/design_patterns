class Modal_controller
  def initialize(view, parent_controller)
    self.view = view
    self.parent_controller = parent_controller
  end

  def valid_data?(data)
    raise NotImplementedError
  end

  def populate_fields
    raise NotImplementedError
  end

  def on_ok(data)
    raise NotImplementedError
  end

  def new_entity(data)
    raise NotImplementedError
  end

  def get_entity
    raise NotImplementedError
  end

  protected
  attr_accessor :view, :parent_controller, :entity

  def get_attributes
    raise NotImplementedError
  end
end