require_relative './student_list_view.rb'
require 'student_mvp'

class Base_view_factory
  def self.create_view(parent, type)
    view = nil
    case type
    when :student_list
      view = Student_list_view.new(parent)
      presenter = Student_list_presenter.new(view)
      view.presenter = presenter
    end
    view.setup_ui
    view
  end
end