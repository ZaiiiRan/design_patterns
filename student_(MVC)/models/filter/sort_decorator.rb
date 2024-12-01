require './models/filter/filter_decorator.rb'

class Sort_decorator < Filter_decorator
  def initialize(filter, order)
    super(filter)
    self.order = order
  end

  def apply(filtering_obj)
    raise NotImplementedError
  end
  
  protected
  attr_accessor :order
end