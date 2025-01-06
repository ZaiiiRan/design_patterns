require_relative './filter_decorator'

class Sort_decorator < Filter_decorator
  def initialize(filter, order)
    super(filter)
    self.order = order
  end

  def apply(filter_decorator)
    raise NotImplementedError
  end

  protected
  attr_accessor :order
end