require './filter/filter_decorator'

class Has_git_filter_decorator < Filter_decorator
    def initialize(filter)
        super(filter)
    end

    def apply(filtering_obj)
        if filtering_obj.is_a?(Array)
            super(filtering_obj).select { |student| !student.git.nil? }
        else
            query = super(filtering_obj)
            condition = query.include?("WHERE") ? "AND" : "WHERE"
            "#{query} #{condition} git IS NOT NULL"
        end
    end
end