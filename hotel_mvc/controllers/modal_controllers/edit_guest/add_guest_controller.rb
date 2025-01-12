require_relative './modal_guest_controller.rb'
require_relative '../../../models/guest/guest.rb'

class Add_guest_controller < Modal_guest_controller
  def on_ok(data)
    begin
      self.new_entity(data)
      self.parent_controller.on_add(self.entity)
      self.view.close
    rescue => e
      self.view.show_error_message("Ошибка при добавлении нового гостя: #{e.message}")
    end
  end

  def populate_fields
    self.view.fields.each_key do |key|
      self.view.fields[key].text = ""
    end
  end
end