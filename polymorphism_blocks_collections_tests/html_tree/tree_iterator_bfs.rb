require './tag.rb'
require './tree_iterator.rb'

class Tree_iterator_bfs < Tree_iterator
    private

    def enumerator
        Enumerator.new do |yielder|
            queue = [self.root]
            until queue.empty?
                current = queue.shift
                yielder << current
                queue.concat(current.children) if current.children
            end
        end
    end
end