class Guest
  attr_reader :firstname, :lastname, :email, :phone_number, :birthdate
  attr_accessor :id

  def initialize(firstname:, lastname:, birthdate:, id: nil, phone_number: nil, email: nil)
    self.id = id
    self.firstname = firstname
    self.lastname = lastname
    self.birthdate = birthdate
    self.phone_number = phone_number
    self.email = email
  end

  def self.new_from_hash(hash)
    self.new(**hash.transform_keys(&:to_sym))
  end

  def has_contact?
    !self.phone_number.nil? || !self.email.nil?
  end

  def self.valid_birthdate?(birthdate)
    valid = (birthdate =~ /^\d{2}\.\d{2}\.\d{4}$/)
    begin
        Date.parse(birthdate)
    rescue
        false
    end
    valid
  end

  def self.valid_phone_number?(phone_number)
    phone_number.nil? || phone_number == "" || phone_number =~ /^(?:\+7|8)[\s-]?(?:\(?\d{3}\)?[\s-]?)\d{3}[\s-]?\d{2}[\s-]?\d{2}$/
  end

  def self.valid_email?(email)
    email.nil? || email == "" || email =~ /^[\w+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
  end

  def self.valid_name?(name)
    name =~ /^[А-ЯЁ][а-яё]{1,}(-[А-ЯЁ][а-яё]{1,})?$/
  end

  private
  def birthdate=(birthdate)
    @birthdate = birthdate.is_a?(String) ? Date.parse(birthdate) : birthdate
  end

  def firstname=(firstname)
    unless self.class.valid_name?(firstname)
        raise ArgumentError, "Неверный формат имени"
    end
    @firstname = firstname
  end

  def lastname=(lastname)
    unless self.class.valid_name?(lastname)
        raise ArgumentError, "Неверный формат фамилии"
    end
    @lastname = lastname
  end

  def email=(email)
    unless self.class.valid_email?(email)
      raise ArgumentError, "Неверный формат email"
    end
    @email = email
  end

  def phone_number=(phone_number)
    unless self.class.valid_phone_number?(phone_number)
      raise ArgumentError, "Неверный формат телефона"
    end
    @phone_number = phone_number
  end
end