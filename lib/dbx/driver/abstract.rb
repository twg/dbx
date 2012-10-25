class DBX::Driver::Abstract
  # == Constants ============================================================

  # == Class Methods ========================================================
  
  # == Instance Methods =====================================================
  
  def initialize(config = nil)
    @config = config
  end
  
  def database(name, options = nil)
    if (_database = self.databases[name.to_s])
      return _database
    end
    
    return unless (options and options[:force])
    
    database_create(name)
  end
  
  def databases(options = nil)
    @databases = nil if (options and options[:reload])
    
    @databases ||= begin
      set = DBX::Entity::DatabaseSet.new(self)
      
      database_names.each do |database_name|
        set[database_name] = DBX::Entity::Database.new(database_name, self)
      end
      
      set
    end
    
    if (block_given?)
      @databases.each do |database_name, database|
        yield(database)
      end
    end
    
    @databases
  end
  
  def connect?
    connected = false
    
    connection do |c|
      connected = !!c
    end
    
    connected
  end

  def connection_request
    @connections and @connections.pop or connection_new
  end
  
  def connection_release(_connection)
    @connections ||= [ ]
    
    @connections << _connection
  end
  
  def type
    :abstract
  end

  def database_names
    [ ]
  end
end
