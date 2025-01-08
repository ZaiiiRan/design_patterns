require_relative './modal.rb'
require_relative '../../controllers/modal_controllers/edit_room/add_room_controller.rb'
require_relative '../../controllers/modal_controllers/edit_room/edit_room_controller.rb'

class Modal_factory
  def self.create_modal(parent, parent_controller, type)
    modal = nil
    case type
    when :add_room
      modal = Modal.new(parent, parent_controller, "Добавление новой комнаты")
      modal.controller = Add_room_controller.new(modal, parent_controller)
      self.setup_form_for_edit_room(modal)
    when :edit_room
      modal = Modal.new(parent, parent_controller, "Редактирование комнаты")
      modal.controller = Edit_room_controller.new(modal, parent_controller)
      self.setup_form_for_edit_room(modal)
    end
    modal.setup_buttons
    modal.controller.populate_fields
    modal
  end

  private
  def self.setup_form_for_edit_room(modal)
    labels = {
      "number": "Номер комнаты",
      "capacity": "Максимальное число человек",
      "price": "Цена за ночь"
    }
    modal.setup_form(labels)
  end
end