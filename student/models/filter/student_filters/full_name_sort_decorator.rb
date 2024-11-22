require './models/filter/filter_decorator.rb'

class Full_name_sort_decorator < Filter_decorator
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
        "#{student.first_name} #{student.name} #{student.patronymic}".downcase
      end

      sorted_students.reverse! if self.order == :desc

      return sorted_students
    else
      query = super(filtering_obj)
      "#{query} ORDER BY CONCAT(first_name, ' ', name, ' ', patronymic) #{self.order == :asc ? 'ASC' : 'DESC'}"
    end
  end

  private
  attr_accessor :order
end