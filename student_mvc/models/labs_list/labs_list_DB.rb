require 'mysql2'
require_relative '../lab/lab.rb'
require_relative '../data_list/data_list_lab.rb'
require_relative '../../data_access/DB_client/DB_client.rb'
require_relative './labs_list_interface.rb'

class Labs_list_DB < Labs_list_interface
  def get_lab_by_id(id)
    result = DB_client.instance.query("SELECT * FROM lab WHERE id = ?", [id])
    row = result.first
    return nil unless row

    Lab.new_from_hash(row)
  end

  def get_labs(data_list = nil)
    query = "SELECT * FROM lab ORDER BY id"
    result = DB_client.instance.query(query)
    labs = result.map { |row| Lab.new_from_hash(row) }
    data_list ||= Data_list_lab.new(labs)
    data_list.index = 1
    data_list.data = labs
    data_list
  end

  def add_lab(lab)
    query = <<-SQL
      INSERT INTO lab (name, topics, tasks, date_of_issue)
      VALUES (?, ?, ?, ?)
    SQL

    begin
      DB_client.instance.query(query, [
        lab.name,
        lab.topics,
        lab.tasks,
        lab.date_of_issue
      ])
    rescue Mysql2::Error => e
      if e.message.include?('Duplicate entry')
        raise "Student with this unique value already exists - #{e.message}"
      else
        raise e
      end
    end
  end

  def replace_lab(id, new_lab)
    query = <<-SQL
      UPDATE lab
      SET name = ?, topics = ?, tasks = ?, date_of_issue = ?
      WHERE id = ?
    SQL

    begin
      DB_client.instance.query(query, [
        new_lab.name,
        new_lab.topics,
        new_lab.tasks,
        new_lab.date_of_issue,
      ])
    rescue Mysql2::Error => e
      if e.message.include?('Duplicate entry')
        raise "Error: Student with this unique value already exists - #{e.message}"
      else
        raise e
      end
    end
  end

  def delete_lab(id)
    query = "DELETE FROM lab WHERE id = ?"
    DB_client.instance.query(query, [id])
  end
end