require './deep_dup/deep_dup.rb'

class Data_list
    include Deep_dup

    attr_accessor :index, :count

    # constructor
    def initialize(elements)
        self.data = elements
        self.selected = []
        self.index = 1
        self.observers = []
    end

    # select element id by number
    def select(number)
        raise IndexError, "Index out of bounds" unless self.valid_index?(number)
        self.selected << number
    end

    def select_all
        (0...self.data.size).each do |i|
            self.select(i)
        end
    end

    # get selected ids
    def get_selected
        self.selected.dup
    end

    # clear selected
    def clear_selected
        self.selected = []
    end

    # pattern-method
    def retrieve_data()
        result = []
        result << self.get_names
        result.concat(self.get_data)
        Data_table.new(result)
    end

    # get names (abstract)
    def get_names
        raise NotImplementedError, "Not implemented"
    end

    # get_data
    def get_data()
        result = []
        selected = self.get_selected
        selected.each do |selected_index|
            obj = self.data[selected_index]
            row = build_row(self.index, obj)
            result.append(row)
            self.index += 1
        end
        result
    end

    # data setter
    def data=(data)
        @data = data.map { |element| deep_dup(element) }
    end

    def notify
        observers.each do |observer|
            observer.set_table_params(self.get_names, self.count)
            observer.set_table_data(self.retrieve_data)
        end
    end

    def add_observer(observer)
        self.observers << observer
    end

    protected
    attr_reader :data
    attr_accessor :selected, :observers

    # validate index
    def valid_index?(index)
        index.between?(0, self.data.size - 1)
    end

    # build row method (abstract)
    def build_row(index, obj)
        raise NotImplementedError, "Not implemented"
    end
end