class Tree_iterator
    attr_reader :current

    def initialize(root)
        self.current = root
    end

    def done?
    end

    def next
    end

    protected
    attr_writer :current
end