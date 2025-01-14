require_relative './filter_decorator'

class Sort_decorator < Filter_decorator
  def initialize(filter, field_name, order = :asc)
    super(filter)
    self.order = order
    self.field_name = field_name
  end

  def apply(filtering_object)
    query = super(filtering_object)
    "#{query} ORDER BY
      CASE
        WHEN #{field_name} IS NULL THEN 1
        ELSE 0
      END,
      #{field_name} #{ self.order == :asc ? 'ASC' : 'DESC' }"
  end

  protected
  attr_accessor :order, :field_name
end