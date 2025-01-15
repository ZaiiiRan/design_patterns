require_relative './field_filter_range.rb.rb'

class Field_filter_range_number < Field_filter_range
  def initialize(filter, field, value1, value2)
    super(filter, field, value1, value2)
    self.value1 = self.value1.to_i unless self.value1.nil? || self.value1.empty?
    self.value2 = self.value2.to_i unless self.value2.nil? || self.value2.empty?
  end
end