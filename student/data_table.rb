class Data_table
    # constructor
    def initialize(data)
        self.data = data
    end

    # row count
    def row_count
        self.data.size
    end

    # column count
    def col_count
        if self.data.empty?
            return 0
        end
        self.data[0].size
    end

    # get element
    def get(row, col)
        raise IndexError, "Row out of bounds" unless self.valid_row?(row)
        raise IndexError, "Column out of bounds" unless self.valid_col?(col)
        self.deep_dup(self.data[row][col])
    end

    private
    attr_reader :data

    # data setter
    def data=(data)
        unless data.is_a?(Array) && data.all? {|row| row.is_a?(Array)}
            raise ArgumentError, "Data must be a two-dimensional array"
        end

        @data = data.map{ |row| row.map { |element| deep_dup(element) }}
    end

    # row validation
    def valid_row?(row)
        row.between?(0, self.row_count - 1)
    end

    # column validation
    def valid_col?(col)
        col.between?(0, self.col_count - 1)
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