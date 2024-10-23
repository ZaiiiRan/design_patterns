class Binary_tree_iterator
    attr_reader :current

    def initialize(root)
        self.stack = []
        self.current = nil
        push_left_branch(root)
    end

    def done?
        self.stack.empty?
    end

    def next
        return nil if self.done?
        self.current = stack.pop
        self.push_left_branch(self.current.right)
        self.current
    end

    private
    attr_writer :current
    attr_accessor :stack

    def push_left_branch(node)
        while node
            self.stack.push(node)
            node = node.left
        end
    end
end