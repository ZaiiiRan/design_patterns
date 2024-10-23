require './tag.rb'
require './tree_iterator_dfs.rb'

class Tree
    include Enumerable
    attr_accessor :root

    def initialize(html_string)
        self.root = self.parse_html(html_string)
    end

    # по умолчанию в each будет dfs
    def each(&block)
        dfs(@root, &block)
    end

    def dfs(node)
        iterator = Tree_iterator_dfs.new(node)
        while !iterator.done?
            yield iterator.current
            iterator.next
        end
    end

    def bfs
        queue = [self.root]
        until queue.empty?
            node = queue.shift
            yield node
            queue.concat(node.children)
        end
    end


    private
    def parse_html(html_string)
        stack = []
        current_parent = nil
    
        html_string.scan(/<[^>]+>|[^<]+/) do |token|
            token.strip!
    
            if token.start_with?("<")
                if token.start_with?("</")
                    process_closing_tag(token, stack)
                    current_parent = stack.last
                elsif token.end_with?("/>")
                    process_self_closing_tag(token, current_parent)
                else
                    current_parent = process_opening_tag(token, stack, current_parent)
                end
            elsif !token.empty?
                process_text(token, current_parent)
            end
        end
    
        self.root
    end
    
    # обработка закрывающего тега
    def process_closing_tag(token, stack)
        tag_name = token[2..-2].strip
        if stack.last && stack.last.name == tag_name
            stack.pop # закрываем текущий тег
        end
    end
    
    # обработка самозакрывающихся (одинарных тегов)
    def process_self_closing_tag(token, current_parent)
        tag_content = token[1..-3].strip
        name, attributes_str = tag_content.split(/\s+/, 2)
        attributes = attributes_str ? Tag.parse_attributes(attributes_str) : {}
        tag = Tag.new(name: name, attributes: attributes)
        current_parent.add_child(tag) if current_parent
    end
    
    # обработка открывающего тега
    def process_opening_tag(token, stack, current_parent)
        tag_content = token[1..-2].strip
        name, attributes_str = tag_content.split(/\s+/, 2)
        attributes = attributes_str ? Tag.parse_attributes(attributes_str) : {}
        tag = Tag.new(name: name, attributes: attributes)
    
        if current_parent
            current_parent.add_child(tag)
        else
            self.root = tag
        end
        stack << tag
        tag # возвращаем текущий родитель
    end
    
    # обработка текста внутри тега
    def process_text(token, current_parent)
        current_parent.content += token if current_parent
    end
end