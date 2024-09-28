require './student.rb'



begin
    students = Student.read_from_txt('./students.txt')
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


