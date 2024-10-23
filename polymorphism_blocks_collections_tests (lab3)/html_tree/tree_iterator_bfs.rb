require './tag.rb'

class Tree_iterator_bfs
    attr_reader :current

    def initialize(root)
        self.queue = root.children
        self.current = root
    end

    def done?
        self.queue.empty?
    end

    def next
        return nil if self.done?

        self.current = self.queue.shift
        self.queue.concat(self.current.children)
        current
    end

    private
    attr_writer :current
    attr_accessor :queue
end