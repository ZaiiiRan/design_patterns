require './filter/filter'

class Filter_decorator < Filter
    def initialize(filter)
        self.filter = filter
    end

    def apply(filtering_obj)
        self.filter.apply(filtering_obj)
    end

    protected
    attr_accessor :filter
end