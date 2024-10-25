require './student.rb'
require './student_short.rb'
require './binary_tree.rb'

# reading students from txt file
def read_from_txt(path)
    if path.nil? || path.empty? then
        raise ArgumentError, 'File path is nil or empty'
    end
    unless File.exist?(path) then
        raise ArgumentError, 'File does not exists'
    end

    students = []
    File.open(path, 'r') do |file|
        file.each_line do |line|
            begin
                student = Student.new_from_string(line.strip)
                students << student
            rescue ArgumentError => e
                raise ArgumentError, "#{line.strip} => #{e.message}"
            end
        end
    end

    students
end

#writing students in txt
def write_to_txt(path, students)
    if path.nil? || path.empty? then
        raise ArgumentError, 'File path is nil or empty'
    end
    if students.nil? || students.empty?
        raise ArgumentError, 'Students list is empty or nil'
    end

    File.open(path, 'w') do |file|
        students.each do |student|
            file.puts student.to_line_s
        end
    end
end


def print_students
    begin
        students = read_from_txt('./students.txt')
        students.each do |x|
            puts x.get_info
        end
        
        puts '-------'
        students.each do |x|
            puts x
        end
    rescue ArgumentError => e
        puts e.message
    end
end

def print_tree(tree)
    tree.each { |student| puts student }
end

def find_in_tree(tree)
    puts tree.find(Date.parse("03.06.2004"))
end


tree = Binary_tree.new
begin
    students = read_from_txt('./students.txt')
    students.each do |x|
        tree.add(x)
    end
rescue ArgumentError => e
    puts e.message
end


puts 'tree:'
print_tree(tree)

puts "\n\nfind result"
find_in_tree(tree)



