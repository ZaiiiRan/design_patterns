require 'fox16'
require './views/base_views/base_view_factory.rb'

include Fox

class App < FXMainWindow
    def initialize(app)
        super(app, "Students", width: 1024, height: 768)

        tabs = FXTabBook.new(self, opts: LAYOUT_FILL)

        FXTabItem.new(tabs, "Список студентов")
        student_list = FXVerticalFrame.new(tabs, opts: LAYOUT_FILL)
        self.student_list_view = Base_view_factory.create_view(student_list, :student_list)

        FXTabItem.new(tabs, "Пока неизвестная вкладка")
        FXVerticalFrame.new(tabs, opts: LAYOUT_FILL)

        FXTabItem.new(tabs, "Тоже пока не понятно что тут")
        FXVerticalFrame.new(tabs, opts: LAYOUT_FILL)

        tabs.connect(SEL_COMMAND) do |sender, _selector, index|
            on_tab_changed(index)
        end
    end

    def create
        super
        show(PLACEMENT_SCREEN)
    end

    def on_tab_changed(index)
        if index == 0
            self.student_list_view.refresh_data
        end
    end

    private
    attr_accessor :student_list_view
end