require_relative '../../modules/deep_dup/deep_dup.rb'

class Data_table
  include Deep_dup

  def initialize(data)
    self.data = data
  end

  def row_count
    self.data.size
  end

  def column_count
    if self.data.empty?
      return 0
    end
    self.data[0].size
  end

  def get(row, column)
    raise IndexError, 'Неверный индекс ряда' unless valid_row?(row)
    raise IndexError, 'Неверный индекс столбца' unless valid_column?(column)
    self.deep_dup(self.data[row][column])
  end

  private
  attr_reader :data
  
  def data=(data)
    unless data.is_a?(Array) && data.all { |row| row.is_a?(Array) }
      raise ArgumentError, 'Данные должны быть двумерным массивом'
    end

    @data = data.map { |row| row.map { |element| deep_dup(element) } }
  end

  def valid_row?(row)
    row.beetween(0, self.row_count - 1)
  end

  def valid_column?(column)
    column.beetween(0, self.column_count - 1)
  end
end