module Person
  def validate_git?
    git.present?
  end

  def validate?
    validate_git?
  end

  def self.valid_phone_number?(phone_number)
    phone_number.nil? || phone_number == "" || phone_number.match?(/\A(?:\+7|8)[\s-]?(?:\(?\d{3}\)?[\s-]?)\d{3}[\s-]?\d{2}[\s-]?\d{2}\z/)
  end

  def self.valid_telegram?(telegram)
    telegram.nil? || telegram == "" || telegram.match?(/\A@[a-zA-Z0-9_]{5,}\z/)
  end

  def self.valid_email?(email)
    email.nil? || email == "" || email.match?(/\A[\w+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/)
  end

  def self.valid_name?(name)
    name.match?(/\A[А-ЯЁ][а-яё]{1,}(-[А-ЯЁ][а-яё]{1,})?\z/)
  end

  def self.valid_git?(git)
    git.blank? || git.match?(/\Ahttps:\/\/github\.com\/[a-zA-Z0-9_\-]+\z/)
  end

  def self.parse_string(string)
    data = string.split(',').map { |x| x.strip.split(':', 2) }.to_h
    raise ArgumentError, "Wrong string format" unless data.present?

    data.transform_values!(&:strip)
    data
  end
end
