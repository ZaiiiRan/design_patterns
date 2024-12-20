require 'fox16'
require 'student_mvp'
require_relative '../modal/modal_factory.rb'
require_relative './base_view.rb'

include Fox

class Student_list_view < Base_view
  def initialize(parent)
    super(parent, opts: LAYOUT_FILL)
    self.rows_per_page = 10
  end

  def setup_ui
    self.filters = {}
    setup_filtering_area
    setup_table_area
    setup_control_buttons_area
    self.current_page = 1
    self.total_pages = 1
    refresh_data
  end

  def update_view(data)
    set_table_params(data[:columns], data[:total_count]) unless data[:total_count].nil? || data[:columns].nil?
    set_table_data(data[:table_data]) unless data[:table_data].nil?
    update_button_states
  end

  def set_table_params(column_names, whole_entities_count)
    column_names.each_with_index do |name, index|
      self.table.setColumnText(index, name)
    end
    self.total_pages = (whole_entities_count / self.rows_per_page.to_f).ceil
    self.total_pages = 1 if self.total_pages == 0
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
    self.presenter.refresh_data
  end

  # update button states method
  def update_button_states
    selected_rows = self.presenter.get_selected
  
    self.add_btn.enabled = true
    self.update_btn.enabled = true
  
    case selected_rows.size
    when 0
      self.edit_btn.enabled = false
      self.delete_btn.enabled = false
      self.edit_git_btn.enabled = false
      self.edit_contacts_btn.enabled = false
    when 1
      self.edit_btn.enabled = true
      self.delete_btn.enabled = true
      self.edit_git_btn.enabled = true
      self.edit_contacts_btn.enabled = true
    else
      self.edit_btn.enabled = false
      self.edit_git_btn.enabled = false
      self.edit_contacts_btn.enabled = false
      self.delete_btn.enabled = true
    end
  end

  private
  attr_accessor :table, :page_label, :prev_btn, :next_btn,
    :add_btn, :update_btn, :edit_btn, :edit_git_btn, :edit_contacts_btn, :delete_btn

  # clear table method
  def clear_table
    (0...self.table.numRows).each do |row|
      (0...self.table.numColumns).each do |col|
        self.table.setItemText(row, col, "")
      end
    end
  end

  def update_page_label
    self.page_label.text = "Страница: #{self.current_page}/#{self.total_pages}"
  end

  def on_add
    modal_view = Modal_factory.create_modal(self, self.presenter, :add_student)
    modal_view.create
    modal_view.show(PLACEMENT_OWNER)
  end
  
  def on_update
    self.refresh_data
  end
  
  def on_edit
    modal_view = Modal_factory.create_modal(self, self.presenter, :replace_student)
    modal_view.create
    modal_view.show(PLACEMENT_OWNER)
  end

  def on_edit_git
    modal_view = Modal_factory.create_modal(self, self.presenter, :edit_git)
    modal_view.create
    modal_view.show(PLACEMENT_OWNER)
  end

  def on_edit_contacts
    modal_view = Modal_factory.create_modal(self, self.presenter, :edit_contacts)
    modal_view.create
    modal_view.show(PLACEMENT_OWNER)
  end
  
  def on_delete
    self.presenter.delete_student
  end

  def switch_page(direction)
    self.presenter.switch_page(direction)
  end

  def reset_filters
    self.filters.each_value do |field|
      field[:combo].setCurrentItem(0) if !field[:combo].nil?
      field[:text_field].text = ""
    end
    self.refresh_data
  end

  def on_row_select(pos)
    self.presenter.select(self.table.getItemText(pos.row, 0).to_i)
  end

  def on_row_deselect(pos)
    self.presenter.deselect(self.table.getItemText(pos.row, 0).to_i)
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

  def setup_table_area
    table_area = FXVerticalFrame.new(self, opts: LAYOUT_FILL)

    self.table = FXTable.new(table_area, opts: LAYOUT_FILL | TABLE_READONLY | TABLE_COL_SIZABLE)

    self.table.setTableSize(self.rows_per_page, 4)
    self.table.rowHeaderMode = LAYOUT_FIX_WIDTH
    self.table.rowHeaderWidth = 30

    self.table.connect(SEL_SELECTED) do |_, _, row|
      on_row_select(row)
    end
    self.table.connect(SEL_DESELECTED) do |_, _, row|
      on_row_deselect(row)
    end

    controls = FXHorizontalFrame.new(table_area, opts: LAYOUT_FILL_X)
    self.prev_btn = FXButton.new(controls, "<", opts: BUTTON_NORMAL | LAYOUT_LEFT)
    self.page_label = FXLabel.new(controls, "Страница: 1/1", opts: LAYOUT_CENTER_X)
    self.next_btn = FXButton.new(controls, ">", opts: BUTTON_NORMAL | LAYOUT_RIGHT)

    self.prev_btn.connect(SEL_COMMAND) { switch_page(-1) }
    self.next_btn.connect(SEL_COMMAND) { switch_page(1) }
    self.table.columnHeader.connect(SEL_COMMAND) do |_, _, column_index|
      self.presenter.set_sort_order(column_index)
    end
  end

  def setup_control_buttons_area
    button_area = FXHorizontalFrame.new(parent, opts: LAYOUT_FILL_X | PACK_UNIFORM_WIDTH)

    self.add_btn = FXButton.new(button_area, "Добавить", opts: BUTTON_NORMAL)
    self.update_btn = FXButton.new(button_area, "Обновить", opts: BUTTON_NORMAL)
    self.edit_btn = FXButton.new(button_area, "Изменить", opts: BUTTON_NORMAL)
    self.edit_git_btn = FXButton.new(button_area, "Изменить Git", opts: BUTTON_NORMAL)
    self.edit_contacts_btn = FXButton.new(button_area, "Изменить контакты", opts: BUTTON_NORMAL)
    self.delete_btn = FXButton.new(button_area, "Удалить", opts: BUTTON_NORMAL)

    self.add_btn.connect(SEL_COMMAND) { on_add }
    self.update_btn.connect(SEL_COMMAND) { on_update }
    self.edit_btn.connect(SEL_COMMAND) { on_edit }
    self.delete_btn.connect(SEL_COMMAND) { on_delete }
    self.edit_git_btn.connect(SEL_COMMAND) { on_edit_git }
    self.edit_contacts_btn.connect(SEL_COMMAND) { on_edit_contacts }
    update_button_states
  end
end