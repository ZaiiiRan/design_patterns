require './binary_tree_iterator.rb'

class Binary_tree
    include Enumerable

    RED = true
    BLACK = false

    class Node
        attr_accessor :value, :left, :right, :color, :parent

        def initialize(value, color = RED)
            self.value = value
            self.left = nil
            self.right = nil
            self.color = color
            self.parent = nil
        end
    end

    attr_accessor :root

    def initialize
        self.root = nil
    end

    def add(value)
        new_node = Node.new(value)
        self.root = insert(self.root, new_node)
        self.balance(new_node)
    end

    def each(&block)
        iterator = Binary_tree_iterator.new(self.root)
        iterator.each(&block)
    end

    def find(key)
        result = nil
        self.each do |value|
            if value.key == key
                result = value
                break
            end
        end
        result
    end

    private
    def insert(root, node)
        if root.nil?
            return node
        elsif node.value < root.value
            root.left = insert(root.left, node)
            root.left.parent = root
        else
            root.right = insert(root.right, node)
            root.right.parent = root
        end
        root
    end

    # метод для балансировки узла
    def balance(node)
        while node != self.root && node.parent.color == RED
            if node.parent == node.parent.parent.left
                balance_with_uncle_on_left(node)
            else
                balance_with_uncle_on_right(node)
            end
        end
        self.root.color = BLACK
    end

    # балансировка, когда дядя находится слева
    def balance_with_uncle_on_left(node)
        uncle = node.parent.parent.right

        if uncle&.color == RED  # дядя красный
            recolor(node)
            node = node.parent.parent  # дед
        else
            if node == node.parent.right  # правый узел
                node = node.parent  # поворот влево
                left_rotate(node)
            end
            rotate_and_recolor(node)  # поворот вправо и перекраска
        end
    end

    # балансировка, когда дядя находится справа
    def balance_with_uncle_on_right(node)
        uncle = node.parent.parent.left

        if uncle&.color == RED  # дядя красный
            recolor(node)
            node = node.parent.parent  # дед
        else
            if node == node.parent.left  # левый узел
                node = node.parent  # поворот вправо
                right_rotate(node)
            end
            rotate_and_recolor(node)  # поворот вправо и перекраска
        end
    end

    # перекраска дяди и деда
    def recolor(node)
        node.parent.color = BLACK  # родителя в черный
        node.parent.parent.color = RED  # деда в красный
        uncle = node.parent.parent.right 
        uncle.color = BLACK if uncle  # дядю в черный
    end

    # поворачиваем узел вправо и перекрашиваем
    def rotate_and_recolor(node)
        node.parent.color = BLACK  # родителя в черный
        node.parent.parent.color = RED  # деда в красный
        right_rotate(node.parent.parent)  # поворот деда вправо
    end

    # левое вращение
    def left_rotate(node)
        right_child = node.right
        return if right_child.nil?

        node.right = right_child.left
        right_child.left.parent = node if right_child.left
        right_child.parent = node.parent

        if node.parent.nil?
            self.root = right_child
        elsif node == node.parent.left
            node.parent.left = right_child
        else
            node.parent.right = right_child
        end

        right_child.left = node
        node.parent = right_child
    end

    # правое вращение
    def right_rotate(node)
        left_child = node.left
        return if left_child.nil?

        node.left = left_child.right
        left_child.right.parent = node if left_child.right
        left_child.parent = node.parent

        if node.parent.nil?
            self.root = left_child
        elsif node == node.parent.left
            node.parent.left = left_child
        else
            node.parent.right = left_child
        end

        left_child.right = node
        node.parent = left_child
    end
end