class Base_controller
  def initialize(view)
    self.view = view
  end
  
  protected
  attr_accessor :view, :entities_list, :data_list
end