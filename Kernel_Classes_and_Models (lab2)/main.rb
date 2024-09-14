require './student.rb'

student1 = Student.new(id: 1, first_name: 'Смирнов', name: 'Никита', patronymic: 'Олегович', phone_number: '+7(934)-453-32-11', 
    telegram: '@zaiiran', git: 'https://github.com/ZaiiiRan')

student2 = Student.new(first_name: 'Блягоз', name: 'Амаль', patronymic: 'Хазретович', id: 2, telegram: '@lamafout', git: 'https://github.com/lamafout',
    email: 'lamafout@gmail.com')
student3 = Student.new(first_name: 'Лотарев', name: 'Сергей', patronymic: 'Юрьевич', id: 3, telegram: '@lotarv')

student1.print_info
student2.print_info
student3.print_info