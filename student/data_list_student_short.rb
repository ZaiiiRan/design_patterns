require './data_list.rb'
require './data_table'

class Data_list_student_short < Data_list
    def get_names
        ["№", "full name", "git", "contact"]
    end

    def get_data
        index = 1
        result = [self.get_names]
        selected = self.get_selected
        selected.each do |selected_index|
            obj = self.data[selected_index]
            row = [index, obj.full_name, obj.git, obj.get_any_contact]
            result.append(row)
            index += 1
        end
        Data_table.new(result)
    end
end
