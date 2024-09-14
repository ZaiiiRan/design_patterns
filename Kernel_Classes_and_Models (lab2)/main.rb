require './student.rb'

student1 = Student.new('Смирнов', 'Никита', 'Олегович', 1, '+7(934)-453-32-11', '@zaiiran', nil, 'https://github.com/ZaiiiRan')
student2 = Student.new('Блягоз', 'Амаль', 'Хазретович', 2, '+7(945)-345-22-66', '@lamafout', 'lamafout@gmail.com', 'https://github.com/lamafout')
student3 = Student.new('Лотарев', 'Сергей', 'Юрьевич', 3, nil, '@lotarv')

student1.print_info
student2.print_info
student3.print_info