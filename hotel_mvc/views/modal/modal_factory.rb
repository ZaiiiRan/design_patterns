require_relative './modal.rb'
require_relative '../../controllers/modal_controllers/edit_room/add_room_controller.rb'
require_relative '../../controllers/modal_controllers/edit_room/edit_room_controller.rb'
require_relative '../../controllers/modal_controllers/edit_guest/add_guest_controller.rb'
require_relative '../../controllers/modal_controllers/edit_guest/edit_guest_controller.rb'

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
    when :add_guest
      modal = Modal.new(parent, parent_controller, "Добавление нового гостя")
      modal.controller = Add_guest_controller.new(modal, parent_controller)
      self.setup_form_for_edit_guest(modal)
    when :edit_guest
      modal = Modal.new(parent, parent_controller, "Редактирование гостя")
      modal.controller = Edit_guest_controller.new(modal, parent_controller)
      self.setup_form_for_edit_guest(modal)
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

  def self.setup_form_for_edit_guest(modal)
    labels = {
      "firstname": "Имя",
      "lastname": "Фамилия",
      "birthdate": "Дата рождения",
      "email": "Email",
      "phone_number": "Номер телефона"
    }
    modal.setup_form(labels)
  end
end