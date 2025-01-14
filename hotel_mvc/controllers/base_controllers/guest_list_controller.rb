require_relative './base_controller.rb'
require_relative '../../models/guests_list/guests_list.rb'
require_relative '../../models/guests_list/guests_list_db.rb'
require_relative '../../models/data_list/data_list_guest.rb'

class Guest_list_controller < Base_controller
  def initialize(view)
    super(view)
    self.entities_list = Guests_list.new(Guests_list_db.new)
    self.data_list = Data_list_guest.new([])
    self.data_list.add_observer(view)
  end

  def refresh_data
    self.data_list.clear_selected
    self.reset_filters
    self.apply_sort
    begin
      self.data_list.count = self.entities_list.count
      self.entities_list.get_guests(self.view.current_page, self.view.rows_per_page, self.filters, self.data_list)
      self.view.update_button_states
    rescue
      self.view.show_error_message(error_msg)
    end
  end

  def on_delete
    ids = self.get_selected

    begin
      ids.each do |id|
        self.entities_list.delete_guest(id)
      end
    rescue => e
      self.view.show_error_message("Ошибка при удалении гостя: #{e.message}")
    ensure
      self.refresh_data
      self.check_and_update_page
    end
  end

  def on_add(entity)
    self.entities_list.add_guest(entity)
    self.refresh_data
  end

  def on_edit(entity)
    self.entities_list.update_guest(entity.id, entity)
    self.refresh_data
  end

  def get_entity(id)
    self.entities_list.get_guest_by_id(id)
  end

  private

  def apply_sort
    field = ''
    case self.sort_order[:col_index]
    when 1
      field = 'lastname'
    when 2
      field = 'firstname'
    when 3
      field = 'birthdate'
    when 4
      field = 'email'
    when 5
      field = 'phone_number'
    end
    self.filters = Sort_decorator.new(self.filters, field, self.sort_order[:order]) unless field == ''
  end
end