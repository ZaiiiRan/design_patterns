require './tag.rb'
require './tree_iterator.rb'

class Tree_iterator_dfs < Tree_iterator
    private

    def enumerator
        Enumerator.new do |yielder|
            stack = [self.root]
            until stack.empty?
                current = stack.pop
                yielder << current
                stack.concat(current.children.reverse) if current.children
            end
        end
    end
end