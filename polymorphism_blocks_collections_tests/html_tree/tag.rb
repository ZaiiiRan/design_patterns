class Tag
    attr_accessor :name, :attributes, :children, :content

    def initialize(name: , attributes: {}, children: [], content: "")
        self.name = name
        self.attributes = attributes
        self.children = children
        self.content = content
    end

    def opening_tag
        attrs = attributes.map { |key, value| "#{key}=\"#{value}\"" }.join(" ")
        "<#{self.name}#{" " + attrs unless attrs.empty?}#{" /" if self.closing?}>"
    end

    def closing_tag
        return "</#{self.name}>" unless self.closing?
        ""
    end

    def children_count
        children.length
    end

    def closing?
        ["img", "input"].include?(self.name)
    end

    def add_child(child)
        self.children << child
    end

    def self.parse_attributes(attributes_str)
        attributes = {}
        attributes_str.scan(/([a-zA-Z]+)="([^" >]*)"/) do |key, value|
            attributes[key] = value
        end
        attributes
    end
end