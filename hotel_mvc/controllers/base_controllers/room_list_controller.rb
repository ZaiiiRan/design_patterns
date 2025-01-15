require_relative './base_controller.rb'
require_relative '../../models/rooms_list/rooms_list.rb'
require_relative '../../models/rooms_list/rooms_list_db.rb'
require_relative '../../models/data_list/data_list_room.rb'
require_relative '../../models/filter/sort_decorator.rb'

class Room_list_controller < Base_controller
  def initialize(view)
    super(view)

    self.entities_list = Rooms_list.new(Rooms_list_db.new)
    self.data_list = Data_list_room.new([])
    self.data_list.add_observer(view)
  end

  def refresh_data
    self.data_list.clear_selected
    self.reset_filters
    self.apply_filters
    begin
      self.data_list.count = self.entities_list.count(self.filters)
      self.entities_list.get_rooms(self.view.current_page, self.view.rows_per_page, self.filters, self.data_list)
      self.view.update_button_states
    rescue => e
      self.view.show_error_message(e.message)
    end
  end

  def on_delete
    ids = self.get_selected

    begin
      ids.each do |id|
        self.entities_list.delete_room(id)
      end
    rescue => e
      self.view.show_error_message("Ошибка при удалении: #{e.messgae}")
    ensure
      self.refresh_data
      self.check_and_update_page
    end
  end

  def on_add(entity)
    self.entities_list.add_room(entity)
    self.refresh_data
  end

  def on_edit(entity)
    self.entities_list.update_room(entity.id, entity)
    self.refresh_data

  end

  def get_entity(id)
    self.entities_list.get_room_by_id(id)
  end

  def apply_filters
    self.apply_not_combo_filter('Номер комнаты:', 'number', :number)
    self.apply_range_filter('Максимум человек:', 'capacity', :number)
    self.apply_range_filter('Цена за ночь:', 'price', :number)
    self.apply_sort
  end

  private

  def apply_sort
    field = ''
    case self.sort_order[:col_index]
    when 1
      field = 'number'
    when 2
      field = 'capacity'
    when 3
      field = 'price'
    end
    self.filters = Sort_decorator.new(self.filters, field, self.sort_order[:order]) unless field == ''
  end
end