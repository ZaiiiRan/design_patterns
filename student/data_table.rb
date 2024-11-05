class Data_table
    def initialize(data)
        self.data = data
    end

    private
    attr_reader :data

    def data=(data)
        unless data.is_a?(Array) && data.all? {|row| row.is_a?(Array)}
            raise ArgumentError, "Data must be a two-dimensional array"
        end

        @data = data.map(&:dup)
    end
end