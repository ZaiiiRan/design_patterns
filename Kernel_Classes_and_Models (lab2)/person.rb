class Person
    attr_reader :id, :name, :git


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
    def self.validate_git(git)
        if git.nil? then
            raise ArgumentError, "Git is empty"
        end
    end

    # names validation
    def self.valid_name?(name)
        name =~ /^[А-ЯЁ][а-яё]{1,}(-[А-ЯЁ][а-яё]{1,})?$/
    end

    # git setter
    def git=(git)
        self.class.validate_git(git)
        unless self.class.valid_git?(git)
            raise ArgumentError, "Wrong git link format"
        end
        @git = git
    end

    #name setter
    def name=(name)
        unless self.class.valid_name?(name)
            raise ArgumentError, "Wrong name format"
        end
        @name = name
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