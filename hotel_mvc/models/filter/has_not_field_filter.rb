require_relative './filter_decorator.rb'

class Has_not_field_filter < Filter_decorator
  def initialize(filter, field)
    super(filter)
    self.field = field
  end

  def apply(filtering_object)
    query = super(filtering_object)
    condition = query.include?("WHERE") ? "AND" : "WHERE"
    "#{query} #{condition} (#{field} IS NULL)"
  end

  private
  attr_accessor :field
end