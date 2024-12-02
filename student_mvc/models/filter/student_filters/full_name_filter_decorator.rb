require './models/filter/filter_decorator.rb'

class Full_name_filter_decorator < Filter_decorator
  def initialize(filter, full_name)
    super(filter)
      self.full_name = full_name.strip.downcase unless full_name.nil?
  end

  def apply(filtering_obj)
    return super(filtering_obj) if self.full_name.nil? || self.full_name.empty?

    if filtering_obj.is_a?(Array)
      super(filtering_obj).select do |student| 
        initials = "#{student.get_full_name}"
        initials.downcase.include?(self.full_name)
      end
    else
      query = super(filtering_obj)
      condition = query.include?("WHERE") ? "AND" : "WHERE"
      "#{query} #{condition} CONCAT(LOWER(first_name), ' ', LOWER(LEFT(name, 1)), '.', LOWER(LEFT(patronymic, 1)), '.') LIKE '%#{self.full_name}%'"
    end
  end

  private
  attr_accessor :full_name
end
