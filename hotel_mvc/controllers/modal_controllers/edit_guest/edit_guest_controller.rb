require_relative './modal_guest_controller.rb'
require_relative '../../../models/guest/guest.rb'
require 'date'

class Edit_guest_controller < Modal_guest_controller
  def on_ok(data)
    begin
      self.new_entity(data)
      self.parent_controller.on_edit(self.entity)
      self.view.close
    rescue => e
      self.view.show_error_message("Ошибка при изменении данных гостя: #{e.message}")
    end
  end
  
  def populate_fields
    self.get_entity
    self.view.fields[:firstname].text = self.entity.firstname
    self.view.fields[:lastname].text = self.entity.lastname
    self.view.fields[:email].text = self.entity.email
    self.view.fields[:phone_number].text = self.entity.phone_number
    self.view.fields[:birthdate].text = self.entity.birthdate.strftime('%d.%m.%Y')
  end

  def valid_data?(data)
    data = data.transform_values { |value| value.strip }
    valid = super(data)
    unchanged = self.entity.firstname == data[:firstname] && self.entity.lastname == data[:lastname] &&
      self.entity.birthdate.strftime('%d.%m.%Y') == data[:birthdate] && 
      ((self.entity.email.nil? && data[:email].empty?) || (self.entity.email == data[:email])) &&
      ((self.entity.phone_number.nil? && data[:phone_number].empty?) || (self.entity.phone_number == data[:phone_number]))
    valid && !unchanged
  end
end