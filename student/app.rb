require 'fox16'
require './views/student_list_view.rb'
require './controllers/Student_list_controller.rb'

include Fox

class App < FXMainWindow
    def initialize(app)
        super(app, "Students", width: 1024, height: 768)

        tabs = FXTabBook.new(self, opts: LAYOUT_FILL)

        FXTabItem.new(tabs, "Список студентов")
        student_list = FXVerticalFrame.new(tabs, opts: LAYOUT_FILL)
        student_list_view = Student_list_view.new(student_list)
        student_list_controller = Student_list_controller.new(student_list_view)
        student_list_view.controller = student_list_controller
        student_list_view.refresh_data

        FXTabItem.new(tabs, "Пока неизвестная вкладка")
        FXVerticalFrame.new(tabs, opts: LAYOUT_FILL)

        FXTabItem.new(tabs, "Тоже пока не понятно что тут")
        FXVerticalFrame.new(tabs, opts: LAYOUT_FILL)
    end

    def create
        super
        show(PLACEMENT_SCREEN)
    end
end
