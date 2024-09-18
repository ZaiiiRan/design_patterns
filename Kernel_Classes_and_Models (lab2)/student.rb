class Person
    attr_reader :id, :git


    protected

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

    # checking for git availability
    def validate_git(git)
        if git.nil? then
            raise ArgumentError, "Git is empty"
        end
    end

    # returning hash
    def self.parse_string(string)
        data = string.split(',')
        hash = {}

        data.each do |x|
            pair = x.strip.split(':')
            if pair[0] && !pair[0].strip.empty? && pair[1] then
                hash[pair[0].strip] = pair[1].strip + (pair[2] ? ":#{pair[2].strip}" : '')
            else
                raise ArgumentError, "Wrong string format"
            end
        end

        hash
    end
end

class Student < Person
    attr_reader :first_name, :name, :patronymic, :telegram, :email, :phone_number
    attr_writer :id

    # constructor
    def initialize(first_name:, name:, patronymic:, **params)
        self.id = params[:id]
        self.first_name = first_name
        self.name = name
        self.patronymic = patronymic
        self.set_contacts(git: params[:git], email: params[:email], telegram: params[:telegram], phone_number: params[:phone_number])
    end

    # constructor_from_string
    def self.new_from_string(string)
        hash = self.parse_string(string)

        self.new(
            id: hash['id'].to_i,
            first_name: hash['first_name'],
            name: hash['name'],
            patronymic: hash['patronymic'],
            telegram: hash['telegram'],
            email: hash['email'],
            phone_number: hash['phone_number'],
            git: hash['git']
        )
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

    # get short info in string
    def get_info
        "#{get_full_name}, git: #{self.git}, #{get_any_contact}"
    end

    # get full name in string
    def get_full_name
        "full_name: #{self.first_name} #{self.name[0]}.#{self.patronymic[0]}."
    end

    # get any contact in string
    def get_any_contact
        if telegram then
            "telegram: #{self.telegram}"
        elsif email
            "email: #{self.email}"
        elsif phone_number
            "phone_number: #{self.phone_number}"
        else
            "no contact provided"
        end
    end


    private

    # names validation
    def self.valid_name?(name)
        name =~ /^[А-ЯЁ][а-яё]{1,}(-[А-ЯЁ][а-яё]{1,})?$/
    end

    # checking the availability of email, phone number or telegram
    def validate_contacts(phone_number, telegram, email)
        if phone_number.nil? && telegram.nil? && email.nil? then
            raise ArgumentError, "Phone number, telegram or Email is empty"
        end
    end

    # contacts validation
    def validate(git, phone_number, telegram, email)
        self.validate_git(git)
        self.validate_contacts(phone_number, telegram, email)
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

    # contacts setter
    def set_contacts(contacts)
        validate(contacts[:git], contacts[:phone_number], contacts[:telegram], contacts[:email])

        unless self.class.valid_phone_number?(contacts[:phone_number])
            raise ArgumentError, "Wrong phone number format"
        end
        @phone_number = contacts[:phone_number]

        unless self.class.valid_telegram?(contacts[:telegram])
            raise ArgumentError, "Wrong telegram format"
        end
        @telegram = contacts[:telegram]

        unless self.class.valid_git?(contacts[:git])
            raise ArgumentError, "Wrong git link format"
        end
        @git = contacts[:git]

        unless self.class.valid_email?(contacts[:email])
            raise ArgumentError, "Wrong Email format"
        end
        @email = contacts[:email]
    end
end

class Student_short < Person
    attr_reader :id, :full_name, :contact
    private_class_method :new

    def initialize(id, full_name, git, contact)
        self.id = id
        self.full_name = full_name
        self.git = git
        self.contact = contact
    end

    # constructor from Student object
    def self.new_from_student_obj(student)
        self.new(
            student.id.to_i,
            student.get_full_name.slice(11..-1),
            student.git,
            student.get_any_contact
        )
    end

    # constructor from string
    def self.new_from_string(id, string)
        hash = self.parse_string(string)
        contact = ''
        if hash['telegram'] then
            contact = "telegram: #{hash['telegram']}"
        elsif hash['email']
            contact = "email: #{hash['email']}"
        else 
            contact = "phone_number #{hash['phone_number']}"
        end
        
        self.new(
            id.to_i,
            hash['full_name'],
            hash['git'],
            contact
        )
    end

    private 
    attr_writer :id

    def full_name=(full_name)
        unless self.class.valid_full_name?(full_name)
            raise ArgumentError, "Wrong full name format"
        end
        @full_name = full_name
    end

    def git=(git)
        self.validate_git(git)
        unless self.class.valid_git?(git)
            raise ArgumentError, "Wrong git link format"
        end
        @git = git
    end

    def contact=(contact)
        unless contact
            raise ArgumentError, "Contact is empty"
        end

        if contact.start_with?('telegram:') then
            telegram = contact.slice(9..-1).strip
            unless self.class.valid_telegram?(telegram)
                raise ArgumentError, "Wrong telegram format"
            end
        elsif contact.start_with?('email:')
            email = contact.slice(6..-1).strip
            unless self.class.valid_email?(email)
                raise ArgumentError, "Wrong email format"
            end
        elsif contact.start_with?('phone_number:')
            phone_number = contact.slice(13..-1).strip
            unless self.class.valid_phone_number?(phone_number)
                raise ArgumentError, "Wrong phone number format"
            end
        else
            raise ArgumentError, "Wrong contact format"
        end
        @contact = contact
    end

    # full name validation
    def self.valid_full_name?(name)
        name =~ /^[А-ЯЁ][а-яё]{1,}(-[А-ЯЁ][а-яё]{1,})?\s[А-ЯЁ].\s?[А-ЯЁ].$/
    end
end