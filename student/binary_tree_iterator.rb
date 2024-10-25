class Binary_tree_iterator
    include Enumerable

    attr_reader :root

    def initialize(root)
        self.root = root
    end

    def each(&block)
        self.enumerator.each(&block)
    end

    private
    attr_writer :root

    def enumerator
        Enumerator.new do |yielder|
            stack = []
            push_left_branch(yielder, self.root, stack)
        end
    end

    def push_left_branch(yielder, node, stack)
        while node
            yielder << node.value
            stack.push(node)
            node = node.left
        end

        until stack.empty?
            current = stack.pop
            push_left_branch(yielder, current.right, stack)
        end
    end
end