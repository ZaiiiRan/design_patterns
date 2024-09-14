class Student
    attr_reader :first_name, :name, :patronymic, :telegram, :email, :git
    attr_accessor :id

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
    def self.valid_phone_number?(phone_number)
        phone_number.nil? || phone_number =~ /^(?:\+7|8)[\s-]?(?:\(?\d{3}\)?[\s-]?)\d{3}[\s-]?\d{2}[\s-]?\d{2}$/
    end

    # telegram validation
    def self.valid_telegram?(telegram)
        telegram.nil? || telegram =~ /@[a-zA-Z0-9_]{5,}$/
    end

    # git link validation
    def self.valid_git?(git)
        git.nil? || git =~ %r{^https?://github\.com/[a-zA-Z0-9_\-]+$}
    end

    # email validation
    def self.valid_email?(email)
        email.nil? || email =~ /^[\w+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
    end

    # names validation
    def self.valid_name?(name)
        name =~ /^[А-ЯЁ][а-яё]{1,}(-[А-ЯЁ][а-яё]{1,})?$/
    end

    # phone number setter
    def phone_number=(phone_number)
        unless self.class.valid_phone_number?(phone_number)
            raise ArgumentError, "Wrong phone number format"
        end
        @phone_number = phone_number
    end

    # telegram setter
    def telegram=(telegram)
        unless self.class.valid_telegram?(telegram)
            raise ArgumentError, "Wrong telegram format"
        end
        @telegram = telegram
    end

    # git setter
    def git=(git)
        unless self.class.valid_git?(git)
            raise ArgumentError, "Wrong git link format"
        end
        @git = git
    end

    #email setter
    def email=(email)
        unless self.class.valid_email?(email)
            raise ArgumentError, "Wrong Email format"
        end
        @email = email
    end

    # first name setter
    def first_name=(first_name)
        unless self.class.valid_name?(first_name)
            raise ArgumentError, "Wrong first name format"
        end
        @first_name = first_name
    end

    # name setter
    def name=(name)
        unless self.class.valid_name?(name)
            raise ArgumentError, "Wrong name format"
        end
        @name = name
    end

    # patronymic setter
    def patronymic=(patronymic)
        unless self.class.valid_name?(patronymic)
            raise ArgumentError, "Wrong patronymic format"
        end
        @patronymic = patronymic
    end


    # checking for git availability
    def validate_git(git)
        if git.nil? then
            raise ArgumentError, "Git is empty"
        end
    end

    # checking the availability of email, phone number or telegram
    def validate_contacts(phone_number, telegram, email)
        if phone_number.nil? && telegram.nil? && email.nil? then
            raise ArgumentError, "Phone number, telegram or Email is empty"
        end
    end

    # contacts validation
    def validate(git, phone_number, telegram, email)
        validate_git(git)
        validate_contacts(phone_number, telegram, email)
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