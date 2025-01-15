require_relative './filter_decorator.rb'

class Field_filter < Filter_decorator
  def initialize(filter, field, value)
    super(filter)
    self.field = field
    self.value = value
  end

  def apply(filtering_object)
    query = super(filtering_object)
    condition = query.include?("WHERE") ? "AND" : "WHERE"
    "#{query} #{condition}"
  end

  protected
  attr_accessor :field, :value
end