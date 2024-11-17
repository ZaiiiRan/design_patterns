require 'fox16'
require './data_list/data_list_student_short.rb'
require './student/student.rb'
require './student_short/student_short.rb'

include Fox

class Student_list_view < FXVerticalFrame

  ROWS_PER_PAGE = 5

  def initialize(parent)
    super(parent, opts: LAYOUT_FILL)

    self.filters = {}
    setup_filtering_area
    setup_table_area
    setup_control_buttons_area
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
      sort_table_by_column(column_index)
    end

    populate_table
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

  private
  attr_accessor :table, :data, :total_pages, :current_page, :page_label, :prev_btn, :next_btn, :sort_order,
    :add_btn, :update_btn, :edit_btn, :delete_btn, :filters

  # get selected rows
  def get_selected_rows
    selected_rows = []
    (0...self.table.numRows).each do |row|
      selected_rows << row if self.table.rowSelected?(row)
    end
    selected_rows
  end

  # populate table by mock data
  def populate_table
    data_list = Data_list_student_short.new([
      Student_short.new_from_student_obj(Student.new_from_string('first_name: Лотарев, name: Сергей, patronymic: Юрьевич, git: https://github.com/lotarv, id: 3, telegram: @lotarv, birthdate: 26.10.2004')),
      Student_short.new_from_student_obj(Student.new_from_string('first_name: Смирнов, name: Никита, patronymic: Олегович, git: https://github.com/ZaiiiRan, id: 1, telegram: @zaiiran, phone_number: +7-(934)-453-32-11, birthdate: 03.06.2004')),
      Student_short.new_from_student_obj(Student.new_from_string('first_name: Блягоз, name: Амаль, patronymic: Хазретович, git: https://github.com/lamafout, id: 2, telegram: @lamafout, email: lamafout@gmail.com, birthdate: 14.06.2004')),
      Student_short.new_from_student_obj(Student.new_from_string('first_name: Матюха, name: Филипп, patronymic: Андреевич, git: https://github.com/SerenityFlaim, id: 4, telegram: @SerenityFlaim, birthdate: 09.06.2004')),
      Student_short.new_from_student_obj(Student.new_from_string('first_name: Воробьев, name: Артем, patronymic: Олегович, git: https://github.com/creatior, id: 5, telegram: @artyomvor, birthdate: 25.09.2004')),
      Student_short.new_from_student_obj(Student.new_from_string('first_name: Вавакин, name: Владислав, patronymic: Олегович, git: https://github.com/VavakinV, id: 5, telegram: @Renbhed, birthdate: 16.06.2004')),
    ])
    data_list.select(0)
    data_list.select(1)
    data_list.select(2)
    data_list.select(3)
    data_list.select(4)
    data_list.select(5)

    self.data = data_list.retrieve_data
    self.total_pages = ((self.data.row_count - 1).to_f / ROWS_PER_PAGE).ceil
    self.current_page = 1

    update_table
  end

  # update table method
  def update_table(sorted_data = nil)
    return if self.data.nil? || self.data.row_count <= 1

    (0...self.data.col_count).each do |col_index|
      self.table.setColumnText(col_index, self.data.get(0, col_index).to_s)
    end
    clear_table

    data_to_display = sorted_data || get_page_data(self.current_page)
    data_to_display.each_with_index do |row, row_index|
      row.each_with_index do |cell, col_index|
        self.table.setItemText(row_index, col_index, cell.to_s)
      end
    end

    self.page_label.text = "Страница: #{self.current_page}/#{self.total_pages}"
  end

  # clear table method
  def clear_table
    (0...ROWS_PER_PAGE).each do |row_index|
      (0...self.data.col_count).each do |col_index|
        self.table.setItemText(row_index, col_index, "")
      end
    end
  end

  # getting data for page
  def get_page_data(page_number)
    start_index = (page_number - 1) * ROWS_PER_PAGE + 1
    end_index = start_index + ROWS_PER_PAGE - 1
    data_page = []

    (start_index..end_index).each do |row_index|
      break if row_index >= self.data.row_count
      row = []
      (0...self.data.col_count).each do |col_index|
        row << self.data.get(row_index, col_index)
      end
      data_page << row
    end
    data_page
  end

  # switch page
  def switch_page(direction)
    new_page = self.current_page + direction
    return if new_page < 1 || new_page > self.total_pages
    self.current_page = new_page
    update_table
  end

  # sort
  def sort_table_by_column(column_index)
    return if self.data.nil? || self.data.row_count <= 1

    headers = (0...self.data.col_count).map { |col_index| self.data.get(0, col_index) }

    rows = (1...self.data.row_count).map do |row_index|
      (0...self.data.col_count).map { |col_index| self.data.get(row_index, col_index)}
    end

    self.sort_order ||= {}
    self.sort_order[column_index] = !sort_order.fetch(column_index, false)

    sorted_rows = rows.sort_by { |row| row[column_index] }
    sorted_rows.reverse! unless self.sort_order[column_index]

    all_rows = [headers] + sorted_rows

    self.data = Data_table.new(all_rows)
    update_table
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

  def on_add
  end
  
  def on_update
  end
  
  def on_edit
  end
  
  def on_delete
  end

  def reset_filters
    self.filters.each_value do |field|
      field[:combo].setCurrentItem(0) if !field[:combo].nil?
      field[:text_field].text = ""
    end
    populate_table
  end
end