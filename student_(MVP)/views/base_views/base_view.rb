require 'fox16'
require 'student_mvp'
require_relative './base_view_interface'

include Fox

class Base_view < FXVerticalFrame
  include Base_view_interface
  
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

  def update_view(data)
    raise NotImplementedError
  end

  def show_error(message)
    FXMessageBox.error(self, MBOX_OK, "Ошибка", message)
  end
end