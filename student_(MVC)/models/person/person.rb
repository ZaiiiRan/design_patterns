class Person
    attr_reader :id, :git

    # checking for git availability
    def validate_git?
        !self.git.nil?
    end

    # validate git
    def validate?
        self.validate_git?
    end

    protected

    # phone number validation
    def self.valid_phone_number?(phone_number)
        phone_number.nil? || phone_number == "" || phone_number =~ /^(?:\+7|8)[\s-]?(?:\(?\d{3}\)?[\s-]?)\d{3}[\s-]?\d{2}[\s-]?\d{2}$/
    end

    # telegram validation
    def self.valid_telegram?(telegram)
        telegram.nil? || telegram == "" || telegram =~ /@[a-zA-Z0-9_]{5,}$/
    end

    # git link validation
    def self.valid_git?(git)
        git.nil? || git == "" || git =~ %r{^https?://github\.com/[a-zA-Z0-9_\-]+$}
    end

    # email validation
    def self.valid_email?(email)
        email.nil? || email == "" || email =~ /^[\w+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
    end

    # names validation
    def self.valid_name?(name)
        name =~ /^[А-ЯЁ][а-яё]{1,}(-[А-ЯЁ][а-яё]{1,})?$/
    end

    # git setter
    def git=(git)
        unless self.class.valid_git?(git)
            raise ArgumentError, "Wrong git link format"
        end
        @git = git
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

    def get_any_contact
    end

    def set_contacts
    end

end