require_relative './data_list.rb'
require_relative '../data_table/data_table.rb'

class Data_list_lab < Data_list
  # get names for lab
  def get_names
    ["№", "name", "topics", "tasks", "date_of_issue"]
  end

  def get_size
    self.data.size
  end

  def get_date_of_issue(num)
    self.data[num].date_of_issue
  end

  def get_selected_num
    self.selected[0]
  end

  private

  # build row for lab
  def build_row(index, obj)
    [index, obj.name, obj.topics, obj.tasks, obj.date_of_issue.strftime('%d.%m.%Y')]
  end
end