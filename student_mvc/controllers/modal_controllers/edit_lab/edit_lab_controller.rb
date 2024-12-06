require_relative '../modal_controller'
require_relative '../../../models/lab/lab'

class Edit_lab_controller < Modal_controller
  # constructor
  def initialize(view, parent_controller)
    super(view, parent_controller)
  end

  # do operation
  def operation(data)
    begin
      self.logger.debug "Создание объекта лабы: #{data.to_s}"
      new_entity(data)
      self.parent_controller.on_edit(self.num, self.entity)
      self.view.close
    rescue => e
      error_msg = "Ошибка при изменении лабы:\n#{e.message}"
      self.logger.error error_msg
      self.view.show_error_message(error_msg)
    end
  end

  # new lab object
  def new_entity(data)
    data.delete("num")
    data = data.transform_values do |value|
      stripped = value.strip
      stripped.empty? ? nil : stripped
    end

    attributes = self.get_attributes
    data.each do |key, value|
      attributes[key.to_sym] = value
    end
    self.entity = Lab.new_from_hash(attributes)
  end

  def get_entity
    id = self.parent_controller.get_selected[0]
    begin
      self.entity = self.parent_controller.get_lab(id)
    rescue
      error_msg = "Ошибка при загрузке данных о лабе: #{e.message}"
      self.logger.error error_msg
      self.view.show_error_message(error_msg)
    end
  end

  # valid_data?
  def valid_data?(data)
    data = data.transform_values { |value| value.strip }
    Lab.valid_name?(data["name"]) && Lab.valid_topics?(data["topics"]) && 
      Lab.valid_tasks?(data["tasks"]) && Lab.valid_date_of_issue?(data["date_of_issue"])
  end

  protected
  attr_accessor :num

  # get attributes
  def get_attributes
    {
      id: self.entity&.id,
      name: self.entity&.name,
      topics: self.entity&.topics,
      tasks: self.entity&.tasks,
      date_of_issue: self.entity&.date_of_issue,
    }
  end
end