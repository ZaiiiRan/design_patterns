require 'fox16'
require './models/data_list/data_list_student_short.rb'
require './models/student/student.rb'
require './models/student_short/student_short.rb'
require './controllers/Student_list_controller.rb'

include Fox

class Student_list_view < FXVerticalFrame
  attr_accessor :controller
  attr_reader :current_page

  ROWS_PER_PAGE = 10

  def initialize(parent)
    super(parent, opts: LAYOUT_FILL)
    self.controller = Student_list_controller.new(self)

    self.filters = {}
    setup_filtering_area
    setup_table_area
    setup_control_buttons_area
    self.current_page = 1
    self.total_pages = 1
    self.refresh_data
  end

  def setup_filtering_area
    filtering_area = FXVerticalFrame.new(self, opts: LAYOUT_FILL_X | LAYOUT_SIDE_TOP)
    FXLabel.new(filtering_area, "Фильтрация")

    name_text_field = nil
    FXHorizontalFrame.new(filtering_area, opts: LAYOUT_FILL_X) do |frame|
      FXLabel.new(frame, "Фамилия и инициалы:")
      name_text_field = FXTextField.new(frame, 20, opts: TEXTFIELD_NORMAL)
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
    FXHorizontalFrame.new(parent, opts: LAYOUT_FILL_X) do |frame|
      FXLabel.new(frame, label)
      combo = FXComboBox.new(frame, 3, opts: COMBOBOX_STATIC | FRAME_SUNKEN)
      combo.numVisible = 3
      combo.appendItem("Не важно")
      combo.appendItem("Да")
      combo.appendItem("Нет")
      text_field = FXTextField.new(frame, 15, opts: TEXTFIELD_NORMAL)
      text_field.enabled = false

      self.filters[label] = { combo: combo, text_field: text_field }

      combo.connect(SEL_COMMAND) do
        text_field.enabled = (combo.currentItem == 1)
      end
    end
  end

  def setup_table_area
    table_area = FXVerticalFrame.new(self, opts: LAYOUT_FILL)

    self.table = FXTable.new(table_area, opts: LAYOUT_FILL | TABLE_READONLY | TABLE_COL_SIZABLE)

    self.table.setTableSize(ROWS_PER_PAGE, 4)
    self.table.rowHeaderMode = LAYOUT_FIX_WIDTH
    self.table.rowHeaderWidth = 30

    controls = FXHorizontalFrame.new(table_area, opts: LAYOUT_FILL_X)
    self.prev_btn = FXButton.new(controls, "<", opts: BUTTON_NORMAL | LAYOUT_LEFT)
    self.page_label = FXLabel.new(controls, "Страница: 1/1", opts: LAYOUT_CENTER_X)
    self.next_btn = FXButton.new(controls, ">", opts: BUTTON_NORMAL | LAYOUT_RIGHT)

    self.prev_btn.connect(SEL_COMMAND) { switch_page(-1) }
    self.next_btn.connect(SEL_COMMAND) { switch_page(1) }
    self.table.columnHeader.connect(SEL_COMMAND) do |_, _, column_index|
      # sort_table_by_column(column_index)
    end
  end

  def setup_control_buttons_area
    button_area = FXHorizontalFrame.new(parent, opts: LAYOUT_FILL_X | PACK_UNIFORM_WIDTH)

    self.add_btn = FXButton.new(button_area, "Добавить", opts: BUTTON_NORMAL)
    self.update_btn = FXButton.new(button_area, "Обновить", opts: BUTTON_NORMAL)
    self.edit_btn = FXButton.new(button_area, "Изменить", opts: BUTTON_NORMAL)
    self.delete_btn = FXButton.new(button_area, "Удалить", opts: BUTTON_NORMAL)

    self.add_btn.connect(SEL_COMMAND) { on_add }
    self.update_btn.connect(SEL_COMMAND) { on_update }
    self.edit_btn.connect(SEL_COMMAND) { on_edit }
    self.delete_btn.connect(SEL_COMMAND) { on_delete }

    self.table.connect(SEL_SELECTED) { update_button_states }
    self.table.connect(SEL_DESELECTED) { update_button_states }

    update_button_states
  end

  def set_table_params(column_names, whole_entities_count)
    column_names.each_with_index do |name, index|
      self.table.setColumnText(index, name)
    end
    self.total_pages = (whole_entities_count / ROWS_PER_PAGE.to_f).ceil
    update_page_label
  end

  def set_table_data(data_table)
    clear_table
    (1...data_table.row_count).each do |row|
      (0...data_table.col_count).each do |col|
        self.table.setItemText(row - 1, col, data_table.get(row, col).to_s)
      end
    end
  end

  def refresh_data
    self.current_page = 1
    self.controller.refresh_data
  end

  private
  attr_accessor :table, :total_pages, :page_label, :prev_btn, :next_btn, :sort_order,
    :add_btn, :update_btn, :edit_btn, :delete_btn, :filters
  attr_writer :current_page

  # get selected rows
  def get_selected_rows
    selected_rows = []
    (0...self.table.numRows).each do |row|
      selected_rows << row if self.table.rowSelected?(row)
    end
    selected_rows
  end

  def update_page_label
    self.page_label.text = "Страница: #{self.current_page}/#{self.total_pages}"
  end

  # clear table method
  def clear_table
    (0...self.table.numRows).each do |row|
      (0...self.table.numColumns).each do |col|
        self.table.setItemText(row, col, "")
      end
    end
  end

  def on_add
  end
  
  def on_update
    self.refresh_data
  end
  
  def on_edit
  end
  
  def on_delete
  end

  def switch_page(direction)
    new_page = self.current_page + direction
    if new_page > 0 && new_page <= self.total_pages
      self.current_page = new_page
      self.controller.refresh_data
    end
  end

  # update button states method
  def update_button_states
    selected_rows = get_selected_rows
  
    self.add_btn.enabled = true
    self.update_btn.enabled = true
  
    case selected_rows.size
    when 0
      self.edit_btn.enabled = false
      self.delete_btn.enabled = false
    when 1
      self.edit_btn.enabled = true
      self.delete_btn.enabled = true
    else
      self.edit_btn.enabled = false
      self.delete_btn.enabled = true
    end
  end

  def reset_filters
    self.filters.each_value do |field|
      field[:combo].setCurrentItem(0) if !field[:combo].nil?
      field[:text_field].text = ""
    end
    populate_table
  end
end