require_relative './edit_lab_controller'
require 'date'

class Add_lab_controller < Edit_lab_controller
  # do operation
  def operation(data)
    begin
      self.logger.debug "Создание объекта лабы: #{data.to_s}"
      new_entity(data)
      self.parent_controller.on_add(self.num, self.entity)
      self.view.close
    rescue => e
      error_msg = "Ошибка при добавлении лабы:\n#{e.message}"
      self.logger.error error_msg
      self.view.show_error_message(error_msg)
    end
  end

  # populate fields
  def populate_fields
    self.view.fields.each_key do |key|
      self.view.fields[key].text = ""
    end
    self.num = self.parent_controller.get_last_num + 1
    self.view.fields["num"].text = self.num.to_s
  end

  # valid_data?
  def valid_data?(data)
    self.logger.debug "Проверка валидности данных: #{data.to_s}"
    res = super(data)
    self.logger.info "Валидность данных: #{res}"
    res
  end
end