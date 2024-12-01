require './models/filter/filter_decorator.rb'

class Field_filter_decorator < Filter_decorator
  def initialize(filter, field, value)
    super(filter)
    self.field = field
    self.value = value.strip.downcase
  end

  def apply(filtering_obj)
    if filtering_obj.is_a?(Array)
      super(filtering_obj).select do |student|
        student_value = student.send(self.field).to_s.downcase
        if self.value.nil? || self.value.empty?
          !student_value.nil? && !student_value.empty?
        else
          student_value.include?(self.value)
        end
      end
    else
      query = super(filtering_obj)
      condition = query.include?("WHERE") ? "AND" : "WHERE"
      if self.value.nil? || self.value.empty?
        "#{query} #{condition} (#{self.field} IS NOT NULL AND #{self.field} != '')"
      else
        "#{query} #{condition} #{self.field} LIKE '%#{self.value}%'"
      end
      
    end
  end

  private
  attr_accessor :field, :value
end