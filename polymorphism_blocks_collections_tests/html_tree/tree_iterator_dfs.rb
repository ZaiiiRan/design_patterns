require './tag.rb'
require './tree_iterator.rb'

class Tree_iterator_dfs < Tree_iterator
    def initialize(root)
        self.stack = root.children.reverse
        super root
    end 

    def next
        if self.done? 
            return nil
        end
        self.current = self.stack.pop
        self.stack.concat(self.current.children.reverse)
        self.current
    end

    def done?
        self.stack.empty?
    end

    private
    attr_accessor :stack 
end