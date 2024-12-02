require './logger/logger.rb'

class Base_presenter
  def initialize(view)
    self.view = view
    self.logger = App_logger.instance
  end
  
  protected
  attr_accessor :view, :entities_list, :data_list, :logger
end