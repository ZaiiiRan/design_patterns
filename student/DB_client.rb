require 'mysql2'

class DB_client
    def initialize(db_config)
        self.client = Mysql2::Client.new(db_config)
    end

    def query(query, params=[])
        self.client.prepare(query).execute(*params)
    end

    def close
        self.client.close
    end

    private
    attr_accessor :client
end