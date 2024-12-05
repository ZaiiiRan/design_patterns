require 'student_mvp'
require_relative './base_view_interface'

class Base_view
  include Base_view_interface

  def setup_ui
    raise NotImplementedError
  end

  def update_view(data)
    raise NotImplementedError
  end

  def show_error(message)
    raise NotImplementedError
  end
end