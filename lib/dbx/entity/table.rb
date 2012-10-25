class DBX::Entity::Table
  def initialize(name, database)
    @name = name
    @database = database
  end
  
  def create_sql(name)
    @database and @database.driver and @database.driver.query("SHOW CREATE TABLE #{table_escape(name)}").to_a[1]
  end
end
