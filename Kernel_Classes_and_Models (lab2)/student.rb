class Student
    attr_accessor :id, :first_name, :name, :patronymic, :phone_number, :telegram, :email, :git

    # constructor
    def initialize(first_name, name, patronymic, id=nil, phone_number=nil, telegram=nil, email=nil, git=nil)
        self.id = id
        self.first_name = first_name
        self.name = name
        self.patronymic = patronymic
        self.phone_number = phone_number
        self.telegram = telegram
        self.email = email
        self.git = git
    end

    # print info
    def print_info
        puts '-------------------'

        puts "ID: #{ @id ? @id : 'Not Set' }"
        puts "First Name: #{ @first_name }"
        puts "Name: #{ @name }"
        puts "Patronymic: #{ @patronymic }"
        puts "Phone Number: #{ @phone_number ? @phone_number : 'Not Set' }"
        puts "Telegram: #{ @telegram ? @telegram : 'Not Set' }"
        puts "Email: #{ @email ? @email : 'Not Set' }"
        puts "Git: #{ @git ? @git : 'Not Set' }"

        puts '-------------------'
    end
end