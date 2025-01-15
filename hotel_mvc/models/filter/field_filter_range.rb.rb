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
    query = "#{query} #{condition}"
    
    unless self.value1.nil?
      query = "#{query} #{field} >= #{value1}"
    end

    unless self.value2.nil?
      query += " AND" if !query.end_with?("AND") && !query.end_with?("WHERE")
      query += " #{field} <= #{value2}"
    end

    query
  end

  protected
  attr_accessor :field, :value1, :value2
end