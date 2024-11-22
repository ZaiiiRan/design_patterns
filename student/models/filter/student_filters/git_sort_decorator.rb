require './models/filter/filter_decorator.rb'

class Git_sort_decorator < Filter_decorator
  def initialize(filter, order)
    super(filter)
    self.order = order
  end

  def apply(filtering_obj)
    if filtering_obj.is_a?(Array)
      super(filtering_obj).sort_by do |student|
        value = student.git
        value.empty? ? Float::INFINITY : value.downcase
      end.reverse! if self.order == :desc
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