require_relative './modal_controller'
require_relative '../../models/lab/lab'

class Edit_lab_controller < Modal_controller
  def initialize(view, parent_controller)
    super(view, parent_controller)
  end

  def operation(data)
    begin
      self.logger.debug "Создание объекта лабы: #{data.to_s}"
      new_lab(data)
      self.parent_controller.replace_lab(self.num, self.lab)
      self.view.close
    rescue => e
      error_msg = "Ошибка при изменении лабы:\n#{e.message}"
      self.logger.error error_msg
      self.view.show_error_message(error_msg)
    end
  end

  def new_lab(data)
    data.delete("num")
    data = data.transform_values do |value|
      stripped = value.strip
      stripped.empty? ? nil : stripped
    end

    attributes = self.get_attributes
    data.each do |key, value|
      attributes[key.to_sym] = value
    end
    self.lab = Lab.new_from_hash(attributes)
  end

  def get_lab
    id = self.parent_controller.get_selected[0]
    begin
      self.lab = self.parent_controller.get_lab(id)
    rescue
      error_msg = "Ошибка при загрузке данных о лабе: #{e.message}"
      self.logger.error error_msg
      self.view.show_error_message(error_msg)
    end
  end

  def valid_data?(data)
    data = data.transform_values { |value| value.strip }
    Lab.valid_name?(data["name"]) && Lab.valid_topics?(data["topics"]) && 
      Lab.valid_tasks?(data["tasks"]) && Lab.valid_date_of_issue?(data["date_of_issue"])
  end

  protected
  attr_accessor :lab, :num

  def get_attributes
    {
      id: self.lab&.id,
      name: self.lab&.name,
      topics: self.lab&.topics,
      tasks: self.lab&.tasks,
      date_of_issue: self.lab&.date_of_issue,
    }
  end
end