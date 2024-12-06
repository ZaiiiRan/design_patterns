require './views/modal/modal.rb'
require './controllers/modal_controllers/edit_student/add_student_controller'
require './controllers/modal_controllers/edit_student/replace_student_controller'
require './controllers/modal_controllers/edit_student/edit_git_controller'
require './controllers/modal_controllers/edit_student/edit_contacts_controller'
require './controllers/modal_controllers/edit_lab/add_lab_controller'
require './controllers/modal_controllers/edit_lab/replace_lab_controller'

class Modal_factory
  def self.create_modal(parent, parent_controller, mode)
    modal = nil
    case mode
      when :add_student
        modal = Modal.new(parent, parent_controller, "Добавление студента")
        modal.controller = Add_student_controller.new(modal, parent_controller)
        self.setup_form_for_edit_student(modal)
      when :replace_student
        modal = Modal.new(parent, parent_controller, "Редактирование студента")
        modal.controller = Replace_student_controller.new(modal, parent_controller)
        self.setup_form_for_edit_student(modal)
      when :edit_git
        modal = Modal.new(parent, parent_controller, "Редактирование Git")
        modal.controller = Edit_git_controller.new(modal, parent_controller)
        self.setup_form_for_edit_git(modal)
      when :edit_contacts
        modal = Modal.new(parent, parent_controller, "Редактирование контактов")
        modal.controller = Edit_contacts_controller.new(modal, parent_controller)
        self.setup_form_for_edit_contacts(modal)
      when :add_lab
        modal = Modal.new(parent, parent_controller, "Добавление лабораторной работы")
        modal.controller = Add_lab_controller.new(modal, parent_controller)
        self.setup_form_for_edit_lab(modal)
      when :replace_lab
        modal = Modal.new(parent, parent_controller, "Редактирование лабораторной работы")
        modal.controller = Replace_lab_controller.new(modal, parent_controller)
        self.setup_form_for_edit_lab(modal)
    end
    modal.setup_buttons
    modal.controller.populate_fields
    modal
  end

  private
  def self.setup_form_for_edit_student(modal)
    labels = {
      "first_name" => "Фамилия",
      "name" => "Имя",
      "patronymic" => "Отчество",
      "birthdate" => "Дата рождения"
    }
    modal.setup_form(labels)
  end

  def self.setup_form_for_edit_git(modal)
    labels = {
      "git" => "Git"
    }
    modal.setup_form(labels)
  end

  def self.setup_form_for_edit_contacts(modal)
    labels = {
      "telegram" => "Telegram",
      "email" => "Email",
      "phone_number" => "Телефон"
    }
    modal.setup_form(labels)
  end

  def self.setup_form_for_edit_lab(modal)
    labels = {
      "num" => "№",
      "name" => "Наименование",
      "date_of_issue" => "Дата выдачи",
    }
    big_labels = {
      "topics" => "Темы",
      "tasks" => "Перечень задач",
    }
    modal.setup_form(labels, big_labels)
    modal.fields["num"].enabled = false
  end
end