require './models/filter/filter_decorator.rb'

class Has_not_field_filter_decorator < Filter_decorator
  def initialize(filter, field)
    super(filter)
    self.field = field
  end

  def apply(filtering_obj)
    if filtering_obj.is_a?(Array)
      super(filtering_obj).select do |student|
        student_value = student.send(self.field).to_s
        student_value.nil? || student_value.empty?
      end
    else
      query = super(filtering_obj)
      condition = query.include?("WHERE") ? "AND" : "WHERE"
      "#{query} #{condition} (#{field} = '' OR #{field} IS NULL)"
    end
  end

  private
  attr_accessor :field
end