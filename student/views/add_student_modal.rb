require 'fox16'
require './controllers/add_student_controller'

include Fox

class Add_student_modal < FXDialogBox
  attr_accessor :controller

  def initialize(parent, parent_controller)
    super(parent, "Добавить студента", opts: DECOR_TITLE | DECOR_BORDER, width: 500, height: 200)
    self.controller = Add_student_controller.new(self, parent_controller)
    
    setup_form
    setup_buttons

  end

  def setup_form
    self.fields = {}
    labels = {
      "last_name" => "Фамилия",
      "name" => "Имя",
      "patronymic" => "Отчество",
      "birthdate" => "Дата рождения"
    }

    labels.each do |field_name, label_text|
      FXHorizontalFrame.new(self, opts: LAYOUT_FILL_X | PACK_UNIFORM_WIDTH) do |frame|
        FXLabel.new(frame, "#{label_text}: ")
        self.fields[field_name] = FXTextField.new(frame, 30, opts: TEXTFIELD_NORMAL | LAYOUT_SIDE_RIGHT)
      end
    end
  end

  def setup_buttons
    FXHorizontalFrame.new(self, opts: LAYOUT_FILL_X | PACK_UNIFORM_WIDTH) do |frame|
      FXButton.new(frame, "ОК", opts: BUTTON_NORMAL).connect(SEL_COMMAND) { on_add }
      FXButton.new(frame, "Отмена", opts: BUTTON_NORMAL).connect(SEL_COMMAND) { on_cancel }
    end
  end

  def show_error_message(message)
    FXMessageBox.error(self, MBOX_OK, "Ошибка", message)
  end

  private
  attr_accessor :fields

  def on_add
    student_data = self.fields.transform_values(&:text)
    self.controller.add_student(student_data)
  end

  def on_cancel
    self.close
  end
end