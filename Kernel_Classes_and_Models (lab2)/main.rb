require './student.rb'

student1 = Student.new(id: 1, first_name: 'Смирнов', name: 'Никита', patronymic: 'Олегович', phone_number: '+7-(934)-453-32-11', 
    telegram: '@zaiiran', git: 'https://github.com/ZaiiiRan')

student2 = Student.new(first_name: 'Блягоз', name: 'Амаль', patronymic: 'Хазретович', id: 2, telegram: '@lamafout', git: 'https://github.com/lamafout',
    email: 'lamafout@gmail.com')
student3 = Student.new(first_name: 'Лотарев', name: 'Сергей', patronymic: 'Юрьевич', id: 3, telegram: '@lotarv', git: 'https://github.com/lotarv')

# student1.print_info
# student2.print_info
# student3.print_info

student4 = Student.from_string("id:5, first_name: Иванов, name: Иван, patronymic: Иванович, telegram: @1vann, git: https://github.com/1vandfd")


sh_st4 = Student_short.new_from_student_obj(student4)
puts sh_st4.id
puts sh_st4.full_name
puts sh_st4.git
puts sh_st4.contact

puts '------'

sh_st5 = Student_short.new_from_string(6, "full_name: Петров П.П., git: https://github.com/petr00v, email: petrov@mail.ru")
puts sh_st5.id
puts sh_st5.full_name
puts sh_st5.git
puts sh_st5.contact

