require './student.rb'

student1 = Student.new(id: 1, first_name: 'Смирнов', name: 'Никита', patronymic: 'Олегович', phone_number: '+7-(934)-453-32-11', 
    telegram: '@zaiiran', git: 'https://github.com/ZaiiiRan')

student2 = Student.new(first_name: 'Блягоз', name: 'Амаль', patronymic: 'Хазретович', id: 2, telegram: '@lamafout', git: 'https://github.com/lamafout',
    email: 'lamafout@gmail.com')
student3 = Student.new(first_name: 'Лотарев', name: 'Сергей', patronymic: 'Юрьевич', id: 3, telegram: '@lotarv', git: 'https://github.com/lotarv')
student4 = Student.new_from_string("id:5, first_name: Иванов, name: Иван, patronymic: Иванович, telegram: @1vann, git: https://github.com/1vandfd")

begin
    students = Student.read_from_txt('./students_for_read.txt')
    
    students.each do |x|
        puts x.get_info
    end
rescue ArgumentError => e
    puts e.message
end

