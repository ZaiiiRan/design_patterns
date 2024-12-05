require_relative '../text_field'
require_relative '../combo_box'

class Student_list_view
  attr_accessor :filters, :current_page, :rows_per_page, :total_pages, :presenter, :columns, :table_data, :error_msg

  def initialize
    self.current_page = 1
    self.rows_per_page = 10
    self.total_pages = 1
    self.filters = {
      'name' => { title: 'Фамилия и инициалы', text_field: Text_field.new },
      'Git:' => { title: 'Git', text_field: Text_field.new, combo: Combo_box.new },
      'Email:' => { title: 'Email', text_field: Text_field.new, combo: Combo_box.new },
      'Телефон:' => { title: 'Телефон', text_field: Text_field.new, combo: Combo_box.new },
      'Telegram:' => { title: 'Telegram', text_field: Text_field.new, combo: Combo_box.new }
    }
  end

  def refresh_data
    self.presenter.refresh_data
  end

  def update_view(data)
    self.columns = data[:columns]
    self.total_pages = (data[:total_count].to_f / self.rows_per_page).ceil
    self.total_pages = 1 if self.total_pages == 0
    self.table_data = data[:table_data]
  end

  def table_data=(data_table)
    @table_data = Array.new(data_table.row_count - 1) { Array.new(data_table.col_count) }
    (1...data_table.row_count).each do |row|
      (0...data_table.col_count).each do |col|
        @table_data[row - 1][col] = data_table.get(row, col).to_s
      end
    end
  end

  def table_data
    @table_data
  end

  def show_error(message)
    self.error_msg = message
  end

  def on_update
    self.current_page = 1
    self.refresh_data
  end

  def switch_page(direction)
    self.presenter.switch_page(direction)
  end

  def on_select(selected)
    self.table_data.each do |row|
      self.presenter.deselect(row[0].to_i)
    end
    selected.each do |num|
      self.presenter.select(num.to_i)
    end
  end

  def on_delete
    self.presenter.delete_student
  end

  def on_sort(column_index)
    self.presenter.set_sort_order(column_index)
  end

  def update_button_states
    # в вебе не нужно
  end
end
