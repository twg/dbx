class DBX::Entity::DatabaseSet < Hash
  def initialize(driver = nil)
    @driver = driver
  end
  
  def [](key)
    super(key.to_s)
  end

  def []=(key, value)
    super(key.to_s, value)
  end
  
  def delete(key)
    super(key.to_s)
  end
  
  def create(name, options = nil)
    @driver and @driver.database_create(name, options)
  end

  def create!(name, options = nil)
    @driver and @driver.database_create!(name, options)
  end
  
  def drop(name)
    @driver and @driver.database_drop(name)
  end

  def drop!(name)
    @driver and @driver.database_drop!(name)
  end
end
