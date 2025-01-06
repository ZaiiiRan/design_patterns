require 'mysql2'

class DB_client
  private_class_method :new

  def initialize(db_config)
    raise 'Требуется конфигурация базы данных' unless db_config
    self.client = Mysql2::Client.new(db_config)
  end

  def self.instance(db_config = nil)
    @instance ||= new(db_config)
  end

  def query(query, params = [])
    self.client.prepare(query).execute(*params)
  end

  def close
    self.client.close
  end

  private
  attr_accessor :client
  @instance = nil
end