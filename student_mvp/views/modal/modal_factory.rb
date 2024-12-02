require_relative './modal.rb'
require 'student_mvp'

class Modal_factory
  def self.create_modal(parent, parent_presenter, mode)
    modal = nil
    case mode
      when :add_student
        modal = Modal.new(parent, parent_presenter, "Добавить студента")
        modal.presenter = Add_student_presenter.new(modal, parent_presenter)
        self.setup_form_for_edit_student(modal)
      when :replace_student
        modal = Modal.new(parent, parent_presenter, "Изменить студента")
        modal.presenter = Replace_student_presenter.new(modal, parent_presenter)
        self.setup_form_for_edit_student(modal)
      when :edit_git
        modal = Modal.new(parent, parent_presenter, "Изменить Git")
        modal.presenter = Edit_git_presenter.new(modal, parent_presenter)
        self.setup_form_for_edit_git(modal)
      when :edit_contacts
        modal = Modal.new(parent, parent_presenter, "Изменить контакты")
        modal.presenter = Edit_contacts_presenter.new(modal, parent_presenter)
        self.setup_form_for_edit_contacts(modal)
    end
    modal.setup_buttons
    modal.presenter.populate_fields
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
end