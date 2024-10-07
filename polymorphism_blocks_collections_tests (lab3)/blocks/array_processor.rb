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

    def partition
        true_part = []
        false_part = []
        self.array.each do |element|
            if yield element then
                true_part << element
            else 
                false_part << element
            end
        end
        [true_part, false_part]
    end

    def take_while
        result = []
        self.array.each do |element|
            break unless yield element
            result << element
        end
        result
    end

    def min
        return nil if self.array.nil? || self.array.empty?

        min_element = self.array[0]
        self.array.each do |element|
            min_element = element if yield(element, min_element) < 0
        end
        min_element
    end

    private
    attr_writer :array
end