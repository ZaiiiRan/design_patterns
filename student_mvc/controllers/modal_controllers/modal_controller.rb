require './logger/logger.rb'

class Modal_controller
  # constructor
  def initialize(view, parent_controller)
    self.view = view
    self.parent_controller = parent_controller
    self.logger = App_logger.instance
  end

  # valid data?
  def valid_data?(data)
    raise NotImplementedError
  end

  # populate fields
  def populate_fields
    raise NotImplementedError
  end

  # operation
  def operation(data)
    raise NotImplementedError
  end

  # new entity
  def new_entity(data)
    raise NotImplementedError
  end

  # get entity
  def get_entity
    raise NotImplementedError
  end

  protected
  attr_accessor :view, :parent_controller, :logger, :entity

  # get attributes
  def get_attributes
    raise NotImplementedError
  end
end