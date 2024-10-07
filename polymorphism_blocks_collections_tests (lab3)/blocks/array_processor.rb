class Array_processor
    attr_reader :array

    def initialize(array) 
        self.array = array
    end

    def count
        count = 0
        self.array.each do |element|
            count += 1 if yield element
        end
        count
    end

    def group_by
        result = {}
        self.array.each do |element|
            key = yield element
            result[key] ||= []
            result[key] << element
        end
        result
    end

    private
    attr_writer :array
end