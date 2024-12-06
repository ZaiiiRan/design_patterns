require 'fox16'
require './models/data_list/data_list_student_short.rb'
require './models/student/student.rb'
require './models/student_short/student_short.rb'
require './views/modal/modal_factory.rb'
require './views/base_views/base_view.rb'

include Fox

class Student_list_view < Base_view
  attr_accessor :current_page, :total_pages, :filters

  def initialize(parent)
    super(parent, opts: LAYOUT_FILL)
  end

  def setup_ui
    self.filters = {}
    setup_filtering_area
    setup_table_area(4)
    setup_control_buttons_area
    self.current_page = 1
    self.total_pages = 1
    refresh_data
  end

  def set_table_params(column_names, whole_entities_count)
    super(column_names, whole_entities_count)
    self.total_pages = (whole_entities_count / self.rows_per_page.to_f).ceil
    self.total_pages = 1 if self.total_pages == 0
    update_page_label
  end

  def refresh_data
    self.current_page = 1
    super
  end

  # update button states method
  def update_button_states
    super

    selected_rows = self.controller.get_selected

    case selected_rows.size
    when 0
      self.edit_git_btn.enabled = false
      self.edit_contacts_btn.enabled = false
    when 1
      self.edit_git_btn.enabled = true
      self.edit_contacts_btn.enabled = true
    else
      self.edit_git_btn.enabled = false
      self.edit_contacts_btn.enabled = false
    end
  end

  private
  attr_accessor :page_label, :prev_btn, :next_btn,
    :edit_git_btn, :edit_contacts_btn

  def update_page_label
    self.page_label.text = "Страница: #{self.current_page}/#{self.total_pages}"
  end

  def on_add
    modal_view = Modal_factory.create_modal(self, self.controller, :add_student)
    modal_view.create
    modal_view.show(PLACEMENT_OWNER)
  end
  
  def on_edit
    modal_view = Modal_factory.create_modal(self, self.controller, :replace_student)
    modal_view.create
    modal_view.show(PLACEMENT_OWNER)
  end

  def on_edit_git
    modal_view = Modal_factory.create_modal(self, self.controller, :edit_git)
    modal_view.create
    modal_view.show(PLACEMENT_OWNER)
  end

  def on_edit_contacts
    modal_view = Modal_factory.create_modal(self, self.controller, :edit_contacts)
    modal_view.create
    modal_view.show(PLACEMENT_OWNER)
  end

  def switch_page(direction)
    self.controller.switch_page(direction)
  end

  def reset_filters
    self.filters.each_value do |field|
      field[:combo].setCurrentItem(0) if !field[:combo].nil?
      field[:text_field].text = ""
    end
    self.refresh_data
  end

  def setup_filtering_area
    filtering_area = FXVerticalFrame.new(self, opts: LAYOUT_FILL_X | LAYOUT_SIDE_TOP)
    FXLabel.new(filtering_area, "Фильтрация")

    name_text_field = nil
    FXHorizontalFrame.new(filtering_area, opts: LAYOUT_FILL_X | PACK_UNIFORM_WIDTH) do |frame|
      FXLabel.new(frame, "Фамилия и инициалы:")
      name_text_field = FXTextField.new(frame, 20, opts: TEXTFIELD_NORMAL | LAYOUT_SIDE_RIGHT)
    end

    self.filters['name'] = { text_field: name_text_field }

    add_filtering_row(filtering_area, "Git:")
    add_filtering_row(filtering_area, "Email:")
    add_filtering_row(filtering_area, "Телефон:")
    add_filtering_row(filtering_area, "Telegram:")

    FXButton.new(filtering_area, "Сбросить", opts: BUTTON_NORMAL).connect(SEL_COMMAND) do
      reset_filters
    end
  end

  def add_filtering_row(parent, label)
    FXHorizontalFrame.new(parent, opts: LAYOUT_FILL_X | PACK_UNIFORM_WIDTH) do |frame|
      FXLabel.new(frame, label)
      combo = FXComboBox.new(frame, 3, opts: COMBOBOX_STATIC | FRAME_SUNKEN | LAYOUT_SIDE_RIGHT)
      combo.numVisible = 3
      combo.appendItem("Не важно")
      combo.appendItem("Да")
      combo.appendItem("Нет")
      text_field = FXTextField.new(frame, 20, opts: TEXTFIELD_NORMAL | LAYOUT_SIDE_RIGHT)
      text_field.enabled = false

      self.filters[label] = { combo: combo, text_field: text_field }

      combo.connect(SEL_COMMAND) do
        text_field.enabled = (combo.currentItem == 1)
      end
    end
  end

  def setup_table_area(column_count)
    table_area = super

    controls = FXHorizontalFrame.new(table_area, opts: LAYOUT_FILL_X)
    self.prev_btn = FXButton.new(controls, "<", opts: BUTTON_NORMAL | LAYOUT_LEFT)
    self.page_label = FXLabel.new(controls, "Страница: 1/1", opts: LAYOUT_CENTER_X)
    self.next_btn = FXButton.new(controls, ">", opts: BUTTON_NORMAL | LAYOUT_RIGHT)

    self.prev_btn.connect(SEL_COMMAND) { switch_page(-1) }
    self.next_btn.connect(SEL_COMMAND) { switch_page(1) }
    self.table.columnHeader.connect(SEL_COMMAND) do |_, _, column_index|
      self.controller.set_sort_order(column_index)
    end
  end

  def setup_control_buttons_area
    button_area = super

    self.edit_git_btn = FXButton.new(button_area, "Изменить Git", opts: BUTTON_NORMAL)
    self.edit_contacts_btn = FXButton.new(button_area, "Изменить контакты", opts: BUTTON_NORMAL)

    self.edit_git_btn.connect(SEL_COMMAND) { on_edit_git }
    self.edit_contacts_btn.connect(SEL_COMMAND) { on_edit_contacts }
    
    self.update_button_states
  end
end