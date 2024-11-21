require 'fox16'
require './controllers/edit_student/add_student_controller'
require './controllers/edit_student/replace_student_controller'
require './controllers/edit_student/edit_git_controller'
require './controllers/edit_student/edit_contacts_controller'

include Fox

class Edit_student_modal < FXDialogBox
  attr_accessor :controller, :mode, :fields

  def initialize(parent, parent_controller, mode=:add)
    self.mode = mode
    super(parent, self.title, opts: DECOR_TITLE | DECOR_BORDER, width: 500, height: 350)
    set_controller(parent_controller)
    
    setup_form
    setup_buttons
    self.controller.populate_fields
    enable_ok_btn
  end

  def setup_form
    self.fields = {}
    labels = {
      "first_name" => "Фамилия",
      "name" => "Имя",
      "patronymic" => "Отчество",
      "birthdate" => "Дата рождения",
      "git" => "Git",
      "telegram" => "Telegram",
      "email" => "Email",
      "phone_number" => "Телефон"
    }

    labels.each do |field_name, label_text|
      FXHorizontalFrame.new(self, opts: LAYOUT_FILL_X | PACK_UNIFORM_WIDTH) do |frame|
        FXLabel.new(frame, "#{label_text}: ")
        self.fields[field_name] = FXTextField.new(frame, 30, opts: TEXTFIELD_NORMAL | LAYOUT_SIDE_RIGHT)
        self.fields[field_name].enabled = false
        self.fields[field_name].connect(SEL_CHANGED) do
          enable_ok_btn
        end
      end
    end
  end

  def setup_buttons
    FXHorizontalFrame.new(self, opts: LAYOUT_FILL_X | PACK_UNIFORM_WIDTH) do |frame|
      self.ok_btn = FXButton.new(frame, "ОК", opts: BUTTON_NORMAL)
      self.ok_btn.enabled = false
      self.ok_btn.connect(SEL_COMMAND) { on_ok }
      FXButton.new(frame, "Отмена", opts: BUTTON_NORMAL).connect(SEL_COMMAND) { on_cancel }
    end
  end

  def show_error_message(message)
    FXMessageBox.error(self, MBOX_OK, "Ошибка", message)
  end

  private
  attr_accessor :ok_btn

  def on_ok
    student_data = self.fields.transform_values(&:text)
    self.controller.save_student(student_data)
  end

  def on_cancel
    self.close
  end

  def enable_ok_btn
    student_data = self.fields.transform_values(&:text)
    self.ok_btn.enabled = self.controller.valid_data?(student_data)
  end

  def title
    case self.mode
      when :add
        return "Добавить студента"
      when :replace
        return "Редактировать студента"
      when :edit_git
        return "Редактировать Git"
      when :edit_contacts
        return "Редактировать контакты"
    end
  end

  def set_controller(parent_controller)
    case self.mode
      when :add
        self.controller = Add_student_controller.new(self, parent_controller)
      when :replace
        self.controller = Replace_student_controller.new(self, parent_controller)
      when :edit_git
        self.controller = Edit_git_controller.new(self, parent_controller)
      when :edit_contacts
        self.controller = Edit_contacts_controller.new(self, parent_controller)
    end
  end
end