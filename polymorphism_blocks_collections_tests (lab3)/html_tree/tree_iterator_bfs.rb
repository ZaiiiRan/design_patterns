require './tag.rb'
require './tree_iterator.rb'

class Tree_iterator_bfs < Tree_iterator
    def initialize(root)
        self.queue = root.children
        super root
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
    attr_accessor :queue
end