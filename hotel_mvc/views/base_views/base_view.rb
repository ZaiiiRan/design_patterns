require 'fox16'

include Fox

class Base_view < FXVerticalFrame
  attr_accessor :controller, :rows_per_page, :current_page, :total_pages

  def initialize(parent, opts: nil)
    super(parent, opts: opts)
    self.rows_per_page = 10
  end

  def setup_ui
    raise NotImplementedError
  end

  def set_table_params(column_names, entitites_count)
    column_names.each_with_index do |name, index|
      self.table.setColumnText(index, name)
    end
    self.total_pages = (entitites_count / self.rows_per_page.to_f).ceil
    self.total_pages = 1 if self.total_pages == 0
    self.update_page_label
  end

  def set_table_data(data_table)
    clear_table
    (0...data_table.row_count).each do |row|
      (0...data_table.column_count).each do |col|
        self.table.setItemText(row, col, data_table.get(row, col).to_s)
      end
    end
  end

  def refresh_data
    self.current_page = 1
    self.controller.refresh_data
  end

  def show_error_message(message)
    FXMessageBox.error(self, MBOX_OK, 'Ошибка', message)
  end

  def update_button_states
    selected_rows = self.controller.get_selected

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

  protected
  attr_accessor :table, :prev_btn, :next_btn, :page_label, :add_btn, :update_btn, :edit_btn, :delete_btn

  def update_page_label
    self.page_label.text = "Страница: #{self.current_page}/#{self.total_pages}"
  end

  def on_add
    raise NotImplementedError
  end

  def on_edit
    raise NotImplementedError
  end

  def on_delete
    self.controller.on_delete
  end

  def on_update
    self.refresh_data
  end

  def on_row_select(pos)
    self.controller.select(self.table.getItemText(pos.row, 0).to_i)
  end

  def on_row_deselect(pos)
    self.controller.deselect(self.table.getItemText(pos.row, 0).to_i)
  end

  def clear_table
    (0...self.table.numRows).each do |row|
      (0...self.table.numColumns).each do |col|
        self.table.setItemText(row, col, "")
      end
    end
  end

  def switch_page(direction)
    self.controller.switch_page(direction)
  end

  def setup_table_area(column_count)
    table_area = FXVerticalFrame.new(self, opts: LAYOUT_FILL)

    self.table = FXTable.new(table_area, opts: LAYOUT_FILL | TABLE_READONLY | TABLE_COL_SIZABLE | TABLE_ROW_SIZABLE)

    self.table.setTableSize(self.rows_per_page, column_count)
    self.rows_per_page.times do |row|
      column_count.times do |col|
        self.table.setItemJustify(row, col, FXTableItem::LEFT | FXTableItem::TOP)
      end
    end

    self.table.rowHeaderMode = LAYOUT_FIX_WIDTH
    self.table.rowHeaderWidth = 30

    self.table.connect(SEL_SELECTED) do |_, _, row|
      self.on_row_select(row)
    end

    self.table.connect(SEL_DESELECTED) do |_, _, row|
      self.on_row_deselect(row)
    end

    table_area
  end

  def setup_pagination_area(table_area)
    controls = FXHorizontalFrame.new(table_area, opts: LAYOUT_FILL_X)
    self.prev_btn = FXButton.new(controls, '<', opts: BUTTON_NORMAL | LAYOUT_LEFT)
    self.page_label = FXLabel.new(controls, 'Страница 1/1', opts: LAYOUT_CENTER_X)
    self.next_btn = FXButton.new(controls, '>', opts: BUTTON_NORMAL | LAYOUT_RIGHT)

    self.prev_btn.connect(SEL_COMMAND) { switch_page(-1) }
    self.next_btn.connect(SEL_COMMAND) { switch_page(1) }
  end

  def setup_controls_area
    button_area = FXHorizontalFrame.new(parent, opts: LAYOUT_FILL_X | PACK_UNIFORM_WIDTH)

    self.add_btn = FXButton.new(button_area, 'Добавить', opts: BUTTON_NORMAL)
    self.edit_btn = FXButton.new(button_area, 'Редактировать', opts: BUTTON_NORMAL)
    self.delete_btn = FXButton.new(button_area, 'Удалить', opts: BUTTON_NORMAL)
    self.update_btn = FXButton.new(button_area, 'Обновить', opts: BUTTON_NORMAL)

    self.add_btn.connect(SEL_COMMAND) { on_add }
    self.edit_btn.connect(SEL_COMMAND) { on_edit }
    self.delete_btn.connect(SEL_COMMAND) { on_delete }
    self.update_btn.connect(SEL_COMMAND) { on_update }

    button_area
  end
end