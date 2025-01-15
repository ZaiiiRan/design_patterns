require_relative './field_filter_range.rb.rb'
require 'date'

class Field_filter_range_date < Field_filter_range
  def initialize(filter, field, value1, value2)
    super(filter, field, value1, value2)
    begin
      self.value1 = "'#{Date.parse(value1).to_s}'" unless self.value1.nil? || self.value1.empty?
      self.value2 = "'#{Date.parse(value2).to_s}'" unless self.value2.nil? || self.value2.empty?
    rescue Date::Error, ArgumentError
      raise 'Ошибка парсинга даты'
    end
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