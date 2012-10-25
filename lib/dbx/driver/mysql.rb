require 'mysql2'

class DBX::Driver::MySQL < DBX::Driver::Abstract
  # == Constants ============================================================

  # == Class Methods ========================================================
  
  # == Instance Methods =====================================================

  def type
    :mysql
  end

  def database_names
    query("SHOW DATABASES", :as => :array).to_a.flatten
  end
  
  def database_create(name, options = nil)
    query("CREATE DATABASE #{database_escape(name)}")
    
    database = DBX::Entity::Database.new(name, self)
    
    @databases[name.to_s] = database if (@databases)
    
    database
  end
  alias_method :database_create!, :database_create
  
  def database_drop(name)
    query("DROP DATABASE #{database_escape(name)}")
    
    @databases.delete(name.to_s) if (@databases)
    
    true
  end
  alias_method :database_drop!, :database_drop
  
  def connection
    _connection = self.connection_request
    
    result = yield(_connection) 
  
    self.connection_release(_connection)
    
    result
  end
  
  def connection_new(database = nil)
    _connection = Mysql2::Client.new(@config)
    
    if (database)
      _connection.query("USE #{database_escape(database)}")
    end
    
    _connection
  end
  
  def query(sql, options = nil)
    connection do |c|
      c.query(sql, options || { })
    end
  end
  
  def table_escape(name)
    "`#{name.to_s}`"
  end
  alias_method :database_escape, :table_escape
end
