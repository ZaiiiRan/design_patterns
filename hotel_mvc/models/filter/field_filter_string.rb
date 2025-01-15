require_relative './field_filter.rb'

class Field_filter_string < Field_filter
  def initialize(filter, field, value)
    super(filter, field, value)
    self.value = self.value.strip.downcase
  end

  def apply(filtering_object)
    query = super(filtering_object)
    query = "#{query} (#{self.field} IS NOT NULL AND #{self.field} != '')"

    if !self.value.nil? && !self.value.empty?
      query = "#{query} AND #{self.field} LIKE '%#{self.value}%'"
    end

    query
  end
end