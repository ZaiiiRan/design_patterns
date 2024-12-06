require_relative '../../models/labs_list/labs_list'
require_relative '../../models/labs_list/labs_list_DB'
require_relative '../../models/data_list/data_list_lab'

class Lab_list_controller < Base_controller
  def initialize(view)
    super(view)
    self.logger.debug("Инициализация Lab_list_controller")
    begin
      self.logger.debug("Инициализация Labs_list")
      self.entities_list = Labs_list.new(Labs_list_DB.new)

      self.logger.debug("Инициализация Data_list_lab")
      self.data_list = Data_list_lab.new([])
      self.logger.debug("Подписка view на Data_list_lab")
      self.data_list.add_observer(self.view)
    rescue StandardError => e
      error_msg = "Ошибка при получении доступа: #{e.message}"
      self.logger.error(error_msg)
      self.view.show_error_message(error_msg)
    end
  end

  def refresh_data
    self.logger.info "Обновление таблицы лаб"
    self.data_list.clear_selected
    begin
      self.logger.info("Поиск лаб в хранилище")
      self.data_list = self.entities_list.get_labs(self.data_list)
      self.data_list.notify
      self.view.update_button_states
    rescue => e
      error_msg = "Ошибка при получении данных: #{e.message}"
      self.logger.error(error_msg)
      self.view.show_error_message(error_msg)
    end
    self.logger.info("Таблица лаб обновлена")
  end

  def get_selected
    selected = self.data_list.get_selected
    self.logger.debug "Выделенные лабы: #{selected}"
    selected
  end
end