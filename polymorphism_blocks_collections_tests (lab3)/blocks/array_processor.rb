class Array_processor
    attr_reader :array

    def initialize(array) 
        self.array = array
    end

    # 
    def count
        count = 0
        self.array.each do |element|
            count += 1 if yield element
        end
        count
    end

    private
    attr_writer :array
end