require './models/data_list/data_list.rb'
require './models/data_table/data_table'

class Data_list_student_short < Data_list
    # get_names for student short
    def get_names
        ["№", "full name", "git", "contact"]
    end

    private

    # build row for student short
    def build_row(index, obj)
        [index, obj.full_name, obj.git, obj.get_any_contact]
    end
end
