require './logger/logger.rb'

class Base_controller
  def initialize(view)
    self.view = view
    self.logger = App_logger.instance
  end

  def select(number)
    begin
      self.data_list.select(number)
      self.logger.info "Выделена строка: #{number}"
      self.view.update_button_states
    rescue
      self.logger.error "Ошибка при выделении строки: #{number}"
    end
  end

  def deselect(number)
    begin
      self.data_list.deselect(number)
      self.logger.info "Выделение со строки: #{number} убрано"
      self.view.update_button_states
    rescue
      self.logger.error "Ошибка при удалении выделения строки: #{number}"
    end
  end
  
  protected
  attr_accessor :view, :entities_list, :data_list, :logger
end