require './models/filter/filter_decorator.rb'

class Git_sort_decorator < Filter_decorator
  def initialize(filter, order)
    super(filter)
    self.order = order
  end

  def apply(filtering_obj)
    if filtering_obj.is_a?(Array)
      filtered_students = super(filtering_obj)
      if filtered_students.nil?
        return []
      end

      sorted_students = filtered_students.sort_by do |student|
        value = student.git
        String(value.nil? || value.empty? ? Float::INFINITY : value.downcase)
      end
      sorted_students.reverse! if self.order == :desc
      sorted_students
    else
      query = super(filtering_obj)
      "#{query} ORDER BY 
          CASE 
            WHEN git IS NULL OR git = '' THEN 1 
            ELSE 0 
          END, 
          git #{self.order == :asc ? 'ASC' : 'DESC' }"
    end
  end

  private
  attr_accessor :order
end