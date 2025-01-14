require_relative '../../models/labs_list/labs_list'
require_relative '../../models/labs_list/labs_list_DB'
require_relative '../../models/data_list/data_list_lab'

class Lab_list_controller < Base_controller
  # constructor
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

  # refresh data
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

  # get selected labs
  def get_selected
    selected = super
    self.logger.debug "Выделенные лабы: #{selected}"
    selected
  end

  # get lab by id
  def get_lab(id)
    self.logger.info "Получение лабы по id: #{id}"
    lab = self.entities_list.get_lab_by_id(id)
    self.logger.debug "Лаба: #{lab.to_line_s}"
    lab
  end

  # add lab
  def on_add(num, lab)
    self.logger.info "Добавление лабы в хранилище"
    self.logger.debug "Данные лабы: #{lab.to_line_s}"
    self.check_date_of_issue(num, lab.date_of_issue)
    self.entities_list.add_lab(lab)
    self.logger.info "Лаба добавлена в хранилище"
    self.refresh_data
  end

  # replace lab
  def on_edit(num, lab)
    self.logger.info "Замена лабы с id: #{lab.id}"
    self.logger.debug "Замена лабы: #{lab.to_line_s}"
    self.check_date_of_issue(num, lab.date_of_issue)
    self.entities_list.replace_lab(lab.id, lab)
    self.refresh_data
  end

  # delete lab
  def on_delete
    id = self.get_selected
    begin
      self.logger.info "Удаление лабы с id: #{id[0]}"
      self.entities_list.delete_lab(id[0])
    rescue StandardError => e
      error_msg = "Ошибка при удалении лабы: #{e.message}"
      self.logger.error(error_msg)
      self.view.show_error_message(error_msg)
    end
    self.refresh_data
  end

  # get last num in data_list
  def get_last_num
    self.data_list.get_size
  end

  # get selected num in data list
  def get_selected_num
    self.data_list.get_selected_num
  end

  private

  # check date of issue
  def check_date_of_issue(num, date_of_issue)
    last = get_last_num
    return true if last == 0
  
    check_prev_date(num, date_of_issue, last)
    check_next_date(num, date_of_issue, last)
  end

  # check prev date
  def check_prev_date(num, date_of_issue, last)
    return unless num > 1

    prev_date = data_list.get_date_of_issue(num - 1)
    if prev_date > date_of_issue
      raise_error(num - 1, prev_date, "раньше предыдущей")
    end
  end

  # check next date
  def check_next_date(num, date_of_issue, last)
    return unless num < last 
  
    next_date = data_list.get_date_of_issue(num + 1)
    if next_date < date_of_issue
      raise_error(num + 1, next_date, "позже следующей")
    end
  end

  # raise error (for date validation)
  def raise_error(num, date, message)
    raise StandardError, "Вы не можете выдать эту лабораторную работу #{message}.\nСрок выдачи ЛР №#{num} - #{date.strftime('%d.%m.%Y')}"
  end
end