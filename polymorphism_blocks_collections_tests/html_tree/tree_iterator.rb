class Tree_iterator
    include Enumerable

    attr_reader :root

    def initialize(root)
        self.root = root
    end

    def each
        enumerator = self.enumerator
        enumerator.each { |node| yield node }
    end

    protected
    attr_writer :root

    def enumerator
        raise NotImplementedError
    end
end