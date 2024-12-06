require './logger/logger.rb'

class Modal_controller
  def initialize(view, parent_controller)
    self.view = view
    self.parent_controller = parent_controller
    self.logger = App_logger.instance
  end

  def valid_data?(data)
    raise NotImplementedError
  end

  def populate_fields
    raise NotImplementedError
  end

  def operation(data)
    raise NotImplementedError
  end

  protected
  attr_accessor :view, :parent_controller, :logger

  def get_attributes
    raise NotImplementedError
  end
end