require_relative './student_list_view.rb'
require 'student_mvp'

class Base_view_factory
  def self.create_view(type)
    view = nil
    case type
    when :student_list
      view = Student_list_view.new
      presenter = Student_list_presenter.new(view)
      view.presenter = presenter
    end
    view.refresh_data
    view
  end
end