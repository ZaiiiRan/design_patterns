require './person.rb'
require 'date'

class Student < Person
    attr_reader :first_name, :patronymic, :telegram, :email, :phone_number, :birthdate
    attr_writer :id

    # constructor
    def initialize(first_name:, name:, patronymic:, birthdate:, id: nil, telegram: nil, phone_number: nil, email: nil, git: nil)
        self.id = id
        self.first_name = first_name
        self.name = name
        self.patronymic = patronymic
        self.git = git
        self.set_contacts(email: email, telegram: telegram, phone_number: phone_number)
        self.birthdate = birthdate
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
            git: hash['git'],
            birthdate: hash['birthdate']
        )
    end

    # to string
    def to_s 
        "#{"-------------------\nID: #{self.id}\n" unless self.id.nil?}First Name: #{ self.first_name }\nName: #{ self.name }\nPatronymic: #{ self.patronymic }\nBithdate: #{ self.birthdate }\n#{"Phone Number: #{ self.phone_number }\n" unless self.phone_number.nil?}#{"Telegram: #{ self.phone_number }\n" unless self.telegram}#{"Email: #{ self.email }\n" unless self.email.nil?}#{"Git: #{ self.git }\n" unless self.git.nil?}-------------------"
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

    # to string
    def to_line_s
        data = []
        data << "first_name: #{self.first_name}"
        data << "name: #{self.name}"
        data << "patronymic: #{self.patronymic}"
        data << "git: #{self.git}"
        if self.id then
            data << "id: #{self.id}"
        end
        if self.telegram then
            data << "telegram: #{self.telegram}"
        end
        if self.email then
            data << "email: #{self.email}"
        end
        if self.phone_number then
            data << "phone_number: #{phone_number}"
        end
        data.join(', ')
    end

    # checking for contacts availability
    def validate_contacts
        !self.telegram.nil? || !self.email.nil? || !self.phone_number.nil?
    end

    # validate git and contacts
    def validate
        super && self.validate_contacts
    end

    private
    # birthdate setter
    def birthdate=(birthdate)
        @birthdate = Date.parse(birthdate)
    end

    # first name setter
    def first_name=(first_name)
        unless self.class.valid_name?(first_name)
            raise ArgumentError, "Wrong first name format"
        end
        @first_name = first_name
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
        unless self.class.valid_phone_number?(contacts[:phone_number])
            raise ArgumentError, "Wrong phone number format"
        end
        @phone_number = contacts[:phone_number]

        unless self.class.valid_telegram?(contacts[:telegram])
            raise ArgumentError, "Wrong telegram format"
        end
        @telegram = contacts[:telegram]

        unless self.class.valid_email?(contacts[:email])
            raise ArgumentError, "Wrong Email format"
        end
        @email = contacts[:email]
    end
end