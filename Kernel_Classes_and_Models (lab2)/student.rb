class Student
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

    # id getter
    def id
        id
    end

    # id setter
    def id=(id)
        @id = id
    end

    # first_name getter
    def first_name
        @first_name
    end
    
    # first_name setter
    def first_name=(first_name)
        @first_name = first_name
    end

    # name getter
    def name
        @name
    end

    # name setter
    def name=(name)
        @name = name
    end

    # patronymic getter
    def patronymic
        @patronymic
    end

    # patronymic setter
    def patronymic=(patronymic)
        @patronymic = patronymic
    end

    # phone_number getter
    def phone_number
        @phone_number
    end

    # phone_number setter
    def phone_number=(phone_number)
        @phone_number = phone_number
    end

    # telegram getter
    def telegram
        @telegram
    end

    # telegram setter
    def telegram=(telegram)
        @telegram = telegram
    end

    # email getter
    def email
        @email
    end

    # email setter
    def email=(email)
        @email = email
    end

    # git getter
    def git
        @git
    end

    # git setter
    def git=(git)
        @git = git
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