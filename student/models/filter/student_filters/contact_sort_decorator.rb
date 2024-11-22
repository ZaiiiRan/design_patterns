require './models/filter/filter_decorator.rb'

class Contact_sort_decorator < Filter_decorator
  def initialize(filter, order)
    super(filter)
    self.order = order
  end

  def apply(filtering_obj)
    if filtering_obj.is_a?(Array)
      super(filtering_obj).sort_by do |student|
        self.get_priority(student)
      end.reverse! if self.order == :desc
    else
      query = super(filtering_obj)
      "#{query} ORDER BY 
        CASE
          WHEN telegram IS NOT NULL AND telegram != '' THEN 1
          WHEN email IS NOT NULL AND email != '' THEN 2
          WHEN phone_number IS NOT NULL AND phone_number != '' THEN 3
          ELSE 4
        END #{self.order_clause}
      "
    end
  end

  private
  attr_accessor :order

  def order_clause
    self.order == :asc ? 'ASC' : 'DESC'
  end

  def get_priority(student)
    if student.telegram && !student.telegram.empty?
      1
    elsif student.email && !student.email.empty?
      2
    elsif student.phone_number && !student.phone_number.empty?
      3
    else
      4
    end
  end
end