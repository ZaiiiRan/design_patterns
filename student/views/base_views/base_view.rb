require 'fox16'

include Fox

class Base_view < FXVerticalFrame
  attr_accessor :controller
  
  def initialize(parent, opts: nil)
    super(parent, opts: opts)
  end

  def setup_ui
    raise NotImplementedError
  end

  def set_table_params(column_names, whole_entities_count)
    raise NotImplementedError
  end

  def set_table_data(data_table)
    raise NotImplementedError
  end

  # def show_error_message(message)
  #   FXMessageBox.error(self, MBOX_OK, "Ошибка", message)
  # end
end