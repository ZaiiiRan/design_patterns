class Student
    attr_reader :phone_number
    attr_accessor :id, :first_name, :name, :patronymic, :telegram, :email, :git

    # constructor
    def initialize(first_name:, name:, patronymic:, **params)
        self.id = params[:id]
        self.first_name = first_name
        self.name = name
        self.patronymic = patronymic
        self.phone_number = params[:phone_number]
        self.telegram = params[:telegram]
        self.email = params[:email]
        self.git = params[:git]
    end

    # phone number validation
    def self.validate_phone_number?(phone_number)
        phone_number.nil? || phone_number =~ /^(?:\+7|8)[\s-]?(?:\(?\d{3}\)?[\s-]?)\d{3}[\s-]?\d{2}[\s-]?\d{2}$/
    end

    # phone number setter
    def phone_number=(phone_number)
        unless self.class.validate_phone_number?(phone_number)
            raise ArgumentError, "Wrong phone number format"
        end
        @phone_number = phone_number
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