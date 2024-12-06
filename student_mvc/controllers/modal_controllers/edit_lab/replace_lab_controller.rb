require_relative './edit_lab_controller'
require 'date'

class Replace_lab_controller < Edit_lab_controller
  # populate fields
  def populate_fields
    self.get_entity
    self.view.fields["name"].text = self.entity.name
    self.view.fields["topics"].text = self.entity.topics
    self.view.fields["tasks"].text = self.entity.tasks
    self.view.fields["date_of_issue"].text = self.entity.date_of_issue.strftime("%d.%m.%Y")

    self.num = self.parent_controller.get_selected_num
    self.view.fields["num"].text = self.num.to_s
  end

  # valid data?
  def valid_data?(data)
    data = data.transform_values { |value| value.strip }
    self.logger.debug "Проверка валидности данных: #{data.to_s}"
    valid = super(data)
    unchanged = self.entity.name == data["name"] &&
      self.entity.date_of_issue.strftime("%d.%m.%Y") == data["date_of_issue"] &&
      (self.entity.topics == data["topics"] || (self.entity.topics.nil? && data["topics"].empty?)) && 
      (self.entity.tasks == data["tasks"] || (self.entity.tasks.nil? && data["tasks"].empty?))
    res = valid && !unchanged
    self.logger.info "Валидность данных: #{res}"
    res
  end
end