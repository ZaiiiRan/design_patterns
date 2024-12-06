require_relative './data_list.rb'
require_relative '../data_table/data_table.rb'

class Data_list_lab < Data_list
  # get names for lab
  def get_names
    ["№", "name", "topics", "tasks", "date_of_issue"]
  end

  private

  # build row for lab
  def build_row(index, obj)
    [index, obj.name, obj.topics, obj.tasks, obj.date_of_issue]
  end
end