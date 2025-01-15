require_relative '../modal_controller.rb'
require_relative '../../../models/guest/guest.rb'

class Modal_guest_controller < Modal_controller
  def initialize(view, parent_controller)
    super(view, parent_controller)
  end

  def new_entity(data)
    data = data.transform_values do |value|
      stripped = value.strip
      stripped.empty? ? nil : stripped
    end

    attributes = self.get_attributes
    data.each do |key, value|
      attributes[key.to_sym] = value
    end
    self.entity = Guest.new_from_hash(attributes)
  end

  def get_entity
    id = self.parent_controller.get_selected[0]
    begin
      self.entity = self.parent_controller.get_entity(id)
    rescue => e
      self.view.show_error_message("Ошибка при загрузке данных гостя: #{e.message}")
    end
  end

  def valid_data?(data)
    data = data.transform_values { |value| value.strip }
    Guest.valid_name?(data[:firstname]) && Guest.valid_name?(data[:lastname]) &&
    (data[:email].empty? || Guest.valid_email?(data[:email])) && (data[:phone_number].empty? || Guest.valid_phone_number?(data[:phone_number])) &&
    Guest.valid_birthdate?(data[:birthdate])
  end

  protected
  
  def get_attributes
    {
      id: self.entity&.id,
      firstname: self.entity&.firstname,
      lastname: self.entity&.lastname,
      email: self.entity&.email,
      phone_number: self.entity&.phone_number,
      birthdate: self.entity&.birthdate
    }
  end
end