class DBX::Entity::Database
  attr_reader :name
  attr_reader :driver
  
  def initialize(name, driver = nil)
    @name = name.to_s.dup.freeze
    @driver = driver
  end
  
  def tables
    return unless (@driver)
    
    Hash[
      @driver.query("SHOW_FULL_TABLES").select do |table_name, table_type|
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
    @driver and @driver.query("SHOW CREATE TABLE #{table_escape(name)}").to_a[1]
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
