require_relative './filter_decorator.rb'

class Field_filter_range < Filter_decorator
  def initialize(filter, field, value1, value2)
    super(filter)
    self.field = field
    self.value1 = value1
    self.value2 = value2
  end

  def apply(filtering_object)
    query = super(filtering_object)
    condition = query.include?("WHERE") ? "AND" : "WHERE"
    "#{query} #{condition}"
  end

  protected
  attr_accessor :field, :value1, :value2
end