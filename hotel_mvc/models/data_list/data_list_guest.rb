require_relative './data_list.rb'
require_relative '../data_table/data_table.rb'

class Data_list_guest < Data_list
  def get_names
    ['№', 'Фамилия', 'Имя', 'Дата рождения', 'Email', ' Номер телефона', 'Требуется подтверждение']
  end

  private
  def build_row(index, obj)
    [index, obj.lastname, obj.firstname, obj.birthdate.strftime("%d.%m.%Y"), obj.email, obj.phone_number, 
      obj.has_contact? ? '-' : '+']
  end
end