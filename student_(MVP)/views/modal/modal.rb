require 'fox16'
require './views/modal/modal_interface.rb'

include Fox

class Modal < FXDialogBox
  include Modal_interface

  def initialize(parent, parent_presenter, title)
    super(parent, title, opts: DECOR_TITLE | DECOR_BORDER)
  end

  def setup_form(labels)
    self.fields = {}

    labels.each do |field_name, label_text|
      FXHorizontalFrame.new(self, opts: LAYOUT_FILL_X | PACK_UNIFORM_WIDTH) do |frame|
        FXLabel.new(frame, "#{label_text}: ")
        self.fields[field_name] = FXTextField.new(frame, 30, opts: TEXTFIELD_NORMAL | LAYOUT_SIDE_RIGHT)
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

  def show_error(message)
    FXMessageBox.error(self, MBOX_OK, "Ошибка", message)
  end

  def update_view(data)
    data.each do |field_name, value|
      self.fields[field_name].text = value
    end
  end

  private

  def on_ok
    data = self.fields.transform_values(&:text)
    self.presenter.operation(data)
  end

  def on_cancel
    self.close
  end

  def enable_ok_btn
    data = self.fields.transform_values(&:text)
    self.ok_btn.enabled = self.presenter.valid_data?(data)
  end
end