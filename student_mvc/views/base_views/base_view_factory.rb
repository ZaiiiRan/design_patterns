require './controllers/base_controllers/student_list_controller.rb'
require './views/base_views/student_list_view.rb'
require_relative './lab_list_view'
require_relative '../../controllers/base_controllers/lab_list_controller'

class Base_view_factory
  def self.create_view(parent, type)
    view = nil
    controller = nil
    case type
    when :student_list
      view = Student_list_view.new(parent)
      controller = Student_list_controller.new(view)
    when :lab_list
      view = Lab_list_view.new(parent)
      controller = Lab_list_controller.new(view)
    end
    view.controller = controller
    view.setup_ui
    view
  end
end