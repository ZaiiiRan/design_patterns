require_relative './data_list.rb'
require_relative '../data_table/data_table.rb'

class Data_list_room < Data_list
  def get_names
    ['№', 'Номер комнаты', 'Максимум человек', 'Цена за ночь']
  end

  private
  def build_row(index, obj)
    [index, obj.number, obj.capacity, obj.price]
  end
end