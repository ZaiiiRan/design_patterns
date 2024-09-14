class Student
    attr_accessor :id, :first_name, :name, :patronymic, :phone_number, :telegram, :email, :git

    # constructor
    def initialize(params)
        self.id = params[:id]

        if (!params[:first_name]) then
            raise "Last name not given"
        end
        self.first_name = params[:first_name]

        if (!params[:name]) then
            raise "Name not given"
        end
        self.name = params[:name]

        if (!params[:patronymic]) then
            raise "Patronymic not given"
        end
        self.patronymic = params[:patronymic]

        self.phone_number = params[:phone_number]
        self.telegram = params[:telegram]
        self.email = params[:email]
        self.git = params[:git]
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