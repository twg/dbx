class DBX::Entity::Database
  attr_reader :name
  attr_reader :driver
  attr_reader :schema
  
  def initialize(name, driver = nil)
    @name = name.to_s.dup.freeze
    @driver = driver
  end
  
  def query(sql)
    return unless (@driver)
    
    _connection = @driver.connection_request
    _connection.query("USE #{@driver.database_escape(@name)}")
    
    result = _connection.query(sql)
    
    @driver.connection_release(_connection)
    
    result
  end

  def tables
    return unless (@driver)
    
    Hash[
      self.query("SHOW FULL TABLES").select do |table_name, table_type|
        table_type == 'BASE TABLE'
      end.collect do |table_name, table_type|
        [
          table_name,
          DBX::Entity::Table.new(table_name, self)
        ]
      end
    ]
  end
  
  def table_create_sql(name)
    return unless (@driver)
    
    result = @driver.query("SHOW CREATE TABLE #{@driver.table_escape(name)}")
    
    create_info = result.to_a[0]
    
    create_info and create_info[1]
  end

  def tables_create_sql
    Hash[
      tables.collect do |table_name, table|
        [
          table.name,
          self.table_create_sql(table.name)
        ]
      end
    ]
  end
  
  def create_sql
    self.tables_create_sql
  end
  
  def to_s
    @name
  end
  
  def drop
    @driver and @driver.database_drop(@name) or false
  end
  alias_method :drop!, :drop
  
  def connection_request
    @connections and @connections.pop or @driver and @driver.connection_new(@name)
  end
  
  def connection_release(_connection)
    @connections ||= [ ]
    
    @connections << _connection
  end

  def archive!(filename)
    require 'zip/zip'
    
    Zip::ZipOutputStream.open(filename) do |zip|
      zip.put_next_entry("@schema.sql")
      
      tables.each do |table|
        zip.puts(sql.table_create_sql(table.name))
      end
    end
  end
end
