require 'fox16'

include Fox

class Modal < FXDialogBox
  attr_accessor :controller, :fields

  def initialize(parent, parent_controller, title)
    super(parent, title, opts: DECOR_TITLE | DECOR_BORDER)
  end

  def setup_form(small_labels, big_labels = nil)
    self.fields = {}
  
    # Обработка маленьких текстовых полей
    small_labels.each do |field_name, label_text|
      FXHorizontalFrame.new(self, opts: LAYOUT_FILL_X | PACK_UNIFORM_WIDTH) do |frame|
        FXLabel.new(frame, "#{label_text}: ", opts: LAYOUT_SIDE_LEFT)
        self.fields[field_name] = FXTextField.new(frame, 30, opts: TEXTFIELD_NORMAL | LAYOUT_FILL_X)
        self.fields[field_name].connect(SEL_CHANGED) do
          enable_ok_btn
        end
      end
    end
  
    # Обработка больших текстовых полей
    unless big_labels.nil?
      big_labels.each do |field_name, label_text|
        FXHorizontalFrame.new(self, opts: LAYOUT_FILL_X | PACK_UNIFORM_WIDTH) do |frame|
          FXLabel.new(frame, "#{label_text}: ", opts: LAYOUT_SIDE_LEFT | LAYOUT_FILL_Y )
          self.fields[field_name] = FXText.new(frame, opts: LAYOUT_FILL_X | LAYOUT_FILL_Y | TEXT_WORDWRAP | TEXT_SHOWACTIVE)
          self.fields[field_name].connect(SEL_CHANGED) do
            enable_ok_btn
          end
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
    data = self.fields.transform_values(&:text)
    self.controller.operation(data)
  end

  def on_cancel
    self.close
  end

  def enable_ok_btn
    data = self.fields.transform_values(&:text)
    self.ok_btn.enabled = self.controller.valid_data?(data)
  end
end