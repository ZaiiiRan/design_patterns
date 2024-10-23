require './tag.rb'

class Tree_iterator_dfs
    attr_reader :current

    def initialize(root)
        self.stack = root.children.reverse
        self.current = root
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
    attr_writer :current
end