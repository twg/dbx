class DBX::Entity::Table
  attr_reader :name
  attr_reader :database
  
  def initialize(name, database)
    @name = name
    @database = database
  end
  
  def create_sql(name)
    return unless (@database and @database.driver)
    
    @database.driver.query("SHOW CREATE TABLE #{table_escape(name)}").to_a[1]
  end
end
