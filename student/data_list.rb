class Data_list
    # constructor
    def initialize(elements)
        self.data = elements
    end

    private
    attr_reader :data

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