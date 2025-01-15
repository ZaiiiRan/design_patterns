require_relative './field_filter.rb'

class Field_filter_number < Field_filter
  def initialize(filter, field, value)
    super(filter, field, value)
    self.value = self.value.to_i
  end

  def apply(filtering_object)
    query = super(filtering_object)
    "#{query} #{self.field} IS NOT NULL AND #{self.field} = #{self.value}"
  end
end