require_relative './field_filter_range.rb.rb'

class Field_filter_range_number < Field_filter_range
  def initialize(filter, field, value1, value2)
    super(filter, field, value1, value2)
    self.value1 = self.value1.to_i unless self.value1.nil? || self.value1.empty?
    self.value2 = self.value2.to_i unless self.value2.nil? || self.value2.empty?
  end

  def apply(filtering_object)
    query = super(filtering_object)
    unless self.value1.nil?
      query = "#{query} #{field} >= #{value1}"
    end

    unless self.value2.nil?
      query += " AND" if !query.end_with?("AND") && !query.end_with?("WHERE")
      query += " #{field} <= #{value2}"
    end

    query
  end
end