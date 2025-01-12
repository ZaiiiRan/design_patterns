require_relative './guests_list_interface.rb'
require_relative '../guest/guest.rb'
require_relative '../data_list/data_list_guest.rb'
require 'mysql2'
require './data_access/db_client/db_client.rb'

class Guests_list_db < Guests_list_interface
  def get_guest_by_id(id)
    result = DB_client.instance.query('SELECT * FROM guests WHERE id = ?', [id])
    row = result.row
    return nil unless row
    Guest.new_from_hash(row)
  end

  def get_guests(k, n, filter = nil, data_list = nil)
    base_query = "SELECT * FROM guests"
    filter_query = filter ? filter.apply(base_query) : base_query
    start = (k - 1) * n

    result = DB_client.instance.query(filter_query + " LIMIT ? OFFSET ?", [n, start])
    guests = result.map { |row| Guest.new_from_hash(row) }
    data_list ||= Data_list_guest.new(guests)
    data_list.index = start + 1
    data_list.data = guests
    data_list
  end

  def add_guest(guest)
    query = <<-SQL
      INSERT INTO guests (firstname, lastname, birthdate, email, phone_number) VALUES (?, ?, ?, ?, ?)
    SQL

    begin
      DB_client.instance.query(query, [guest.firstname, guest.lastname, guest.birthdate, guest.email, guest.phone_number])
    rescue Mysql2::Error => e
      if e.message.include?('Duplicate entry')
        raise "Ошибка дубликата: #{e.message}"
      else
        raise e
      end
    end
  end

  def update_guest(id, guest)
    query = <<-SQL
      UPDATE guests SET firstname = ?, lastname = ?, birthdate = ?, email = ?, phone_number = ? WHERE id = ?
    SQL

    begin
      DB_client.instance.query(query, [guest.firstname, guest.lastname, guest.birthdate, guest.email, guest.phone_number, id])
    rescue
      if e.message.include?('Duplicate entry')
        raise "Ошибка дубликата: #{e.message}"
      else
        raise e
      end
    end
  end

  def delete_guest(id)
    DB_client.instance.query('DELETE FROM guests WHERE id = ?', [id])
  end

  def count(filter = nil)
    base_query = "SELECT COUNT(*) AS count FROM guests"
    filter_query = filter ? filter.apply(base_query) : base_query

    result = DB_client.instance.query(filter_query)
    result.first['count']
  end
end