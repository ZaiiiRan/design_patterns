class Data_list
    # constructor
    def initialize(elements)
        self.data = elements
        self.selected = []
    end

    # select element id by number
    def select(number)
        element = self.data[number]
        if element && !self.selected.include?(element.id)
            self.selected << element.id
        end
    end

    # get selected ids
    def get_selected
        self.selected.dup
    end

    # get names
    def get_names
        raise NotImplementedError, "Not implemented"
    end

    # get_data
    def get_data
        raise NotImplementedError, "Not implemented"
    end

    private
    attr_reader :data
    attr_accessor :selected

    # data setter
    def data=(data)
        @data = data.map { |element| deep_dup(element) }
    end

    # deep copy
    def deep_dup(element)
        if element.is_a?(Array)
            element.map { |sub_element| deep_dup(sub_element) }
        else
            begin
                element.dup
            rescue
                element
            end
        end
    end
end