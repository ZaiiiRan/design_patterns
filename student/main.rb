require './student.rb'
require './student_short.rb'
require './binary_tree.rb'
require './data_list_student_short.rb'
require './data_table'
require './students_list.rb'
require './JSON_storage_strategy.rb'
require './YAML_storage_strategy.rb'

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

def test_tree
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
end

def print_table(table)
    (0...table.row_count).each do |i|
        (0...table.col_count).each do |j|
            print "#{table.get(i, j)}\t"
        end
        puts "\n"
    end
end

def test_data_list
    students = read_from_txt('./students.txt')
    student_short_objs = []
    students.each do |x|
        student_short_objs.append(Student_short.new_from_student_obj(x))
    end

    data_list = Data_list_student_short.new(student_short_objs)
    data_list.select(0)
    data_list.select(1)
    data_list.select(2)
    table = data_list.retrieve_data
    print_table table
end

def test_student_list_json
    json = Students_list.new('./students.json', JSON_storage_strategy.new())
    
    data_list = json.get_k_n_student_short_list(1, 5)
    data_list.select(1)
    data_list.select(2)
    table = data_list.retrieve_data
    print_table table
end

def test_student_list_yaml
    yaml = Students_list.new('./students.yaml', YAML_storage_strategy.new())

    yaml.add_student(Student.new_from_string('first_name: Лотарев, name: Сергей, patronymic: Юрьевич, git: https://github.com/lotarv, id: 3, telegram: @lotarv, birthdate: 26.10.2004'))
    yaml.add_student(Student.new_from_string('first_name: Смирнов, name: Никита, patronymic: Олегович, git: https://github.com/ZaiiiRan, id: 1, telegram: @zaiiran, phone_number: +7-(934)-453-32-11, birthdate: 03.06.2004'))
    yaml.add_student(Student.new_from_string('first_name: Блягоз, name: Амаль, patronymic: Хазретович, git: https://github.com/lamafout, id: 2, telegram: @lamafout, email: lamafout@gmail.com, birthdate: 14.06.2004'))
    yaml.write
end

test_student_list_yaml
