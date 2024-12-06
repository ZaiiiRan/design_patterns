require_relative './edit_lab_controller'
require 'date'

class Replace_lab_controller < Edit_lab_controller
  def populate_fields
    self.get_lab
    self.view.fields["name"].text = self.lab.name
    self.view.fields["topics"].text = self.lab.topics
    self.view.fields["tasks"].text = self.lab.tasks
    self.view.fields["date_of_issue"].text = self.lab.date_of_issue.strftime("%d.%m.%Y")

    self.num = self.parent_controller.get_selected_num
    self.view.fields["num"].text = self.num.to_s
  end

  def valid_data?(data)
    self.logger.debug "Проверка валидности данных: #{data.to_s}"
    res = super(data)
    self.logger.info "Валидность данных: #{res}"
    res
  end
end