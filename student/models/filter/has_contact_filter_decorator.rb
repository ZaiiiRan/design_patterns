require './models/filter/filter_decorator.rb'

class Has_contact_filter_decorator < Filter_decorator
    def initialize(filter)
        super(filter)
    end

    def apply(filtering_obj)
        if filtering_obj.is_a?(Array)
            super(filtering_obj).select { |student| !student.phone_number.nil? || !student.email.nil? || !student.telegram.nil? } 
        else
            query = super(filtering_obj)
            condition = query.include?("WHERE") ? "AND" : "WHERE"
            "#{query} #{condition} (phone_number IS NOT NULL OR email IS NOT NULL OR telegram IS NOT NULL)"
        end
    end
end
