require 'mysql2'
require_relative '../room/room.rb'
require_relative '../data_list/data_list_room.rb'
require './data_access/db_client/db_client.rb'
require_relative './rooms_list_interface'

class Rooms_list_db < Rooms_list_interface
  def get_room_by_id(id)
    result = DB_client.instance.query('SELECT * FROM rooms WHERE id = ?', [id])
    row = result.first
    return nil unless row
    Room.new_from_hash(row)
  end

  def get_rooms(k, n, filter = nil, data_list = nil)
    base_query = "SELECT * FROM rooms"
    filter_query = filter ? filter.apply(base_query) : base_query
    start = (k - 1) * n

    result = DB_client.instance.query(filter_query + " LIMIT ? OFFSET ?", [n, start])
    rooms = result.map { |row| Room.new_from_hash(row) }
    data_list ||= Data_list_room.new(rooms)
    data_list.index = start + 1
    data_list.data = student_short
    data_list
  end

  def add_room(room)
    query = <<-SQL
      INSERT INTO rooms (number, capacity, price) VALUES (?, ?, ?)
    SQL

    begin
      DB_client.instance.query(query, [room.number, room.capacity, room.price])
    rescue Mysql2::Error => e
      if e.message.include?('Duplicate entry')
        raise 'Комната с таким номером уже существует'
      else
        raise e
      end
    end
  end

  def update_room(id, room)
    query = <<-SQL
      UPDATE rooms SET number = ?, capacity = ?, price = ? WHERE id = ?
    SQL

    begin
      DB_client.instance.query(query, [room.number, room.capacity, room.price, id])
    rescue Mysql2::Error => e
      if e.message.include?('Duplicate entry')
        raise 'Комната с таким номером уже существует'
      else
        raise e
      end
    end
  end

  def delete_room(id)
    query = "DELETE FROM rooms WHERE id = ?"
    DB_client.instance.query(query, [id])
  end

  def count(filter = nil)
    base_query = "SELECT COUNT(*) AS count FROM rooms"
    filter_query = filter ? filter.apply(base_query) : base_query
    
    result = DB_client.instance.query(filter_query)
    result.first['count']
  end
end