require './controllers/base_controllers/student_list_controller.rb'
require './views/base_views/student_list_view.rb'

class Base_view_factory
  def self.create_view(parent, type)
    view = nil
    case type
    when :student_list
      view = Student_list_view.new(parent)
      controller = Student_list_controller.new(view)
      view.controller = controller
    end
    view.setup_ui
    view
  end
end