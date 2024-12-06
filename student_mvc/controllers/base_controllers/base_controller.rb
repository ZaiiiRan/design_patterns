require './logger/logger.rb'

class Base_controller
  # constructor
  def initialize(view)
    self.view = view
    self.logger = App_logger.instance
  end

  # entity adding
  def on_add
    raise NotImplementedError
  end

  # entity deleting
  def on_delete
    raise NotImplementedError
  end

  # entity replacing
  def on_edit
    raise NotImplementedError
  end

  # get entity
  def get_entity
    raise NotImplementedError
  end

  # select entity in data list
  def select(number)
    begin
      self.data_list.select(number)
      self.logger.info "Выделена строка: #{number}"
      self.view.update_button_states
    rescue
      self.logger.error "Ошибка при выделении строки: #{number}"
    end
  end

  # deselect entity from data list
  def deselect(number)
    begin
      self.data_list.deselect(number)
      self.logger.info "Выделение со строки: #{number} убрано"
      self.view.update_button_states
    rescue
      self.logger.error "Ошибка при удалении выделения строки: #{number}"
    end
  end

  # get selected
  def get_selected
    self.data_list.get_selected
  end
  
  protected
  attr_accessor :view, :entities_list, :data_list, :logger
end