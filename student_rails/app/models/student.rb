class Student < ApplicationRecord
  validates :first_name, :name, :patronymic, format: { with: /\A[А-ЯЁ][а-яё]{1,}(-[А-ЯЁ][а-яё]{1,})?\z/, message: "Неверный формат имени" }
  validates :email, uniqueness: true, allow_blank: true, format: { with: /\A[\w+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/, message: "Неверный формат Email" }
  validates :telegram, uniqueness: true, allow_blank: true, format: { with: /\A@[a-zA-Z0-9_]{5,}\z/, message: "Неверный формат Telegram" }
  validates :phone_number, uniqueness: true, allow_blank: true, format: { with: /\A(?:\+7|8)[\s-]?(?:\(?\d{3}\)?[\s-]?)\d{3}[\s-]?\d{2}[\s-]?\d{2}\z/, message: "Неверный формат номера телефона" }
  validates :git, uniqueness: true, allow_blank: true, format: { with: %r{\Ahttps?://github\.com/[a-zA-Z0-9_\-]+\z}, message: "Неверный формат Git" }

  def self.new_from_string(string)
    data = parse_string(string)
    Student.new(
      id: data["id"].to_i,
      first_name: data["first_name"],
      name: data["name"],
      patronymic: data["patronymic"],
      telegram: data["telegram"],
      email: data["email"],
      phone_number: data["phone_number"],
      git: data["git"],
      birthdate: Date.parse(data["birthdate"])
    )
  end

  def self.new_from_hash(hash)
    Student.new(hash.transform_keys(&:to_sym))
  end

  def get_full_name
    "#{first_name} #{name[0]}.#{patronymic[0]}."
  end

  def get_any_contact
    telegram || email || phone_number || nil
  end

  def validate_contacts?
    telegram.present? || email.present? || phone_number.present?
  end

  def validate_git?
    git.present?
  end

  def validate?
    validate_git? && validate_contacts?
  end
end
