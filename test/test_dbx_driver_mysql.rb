require File.expand_path('helper', File.dirname(__FILE__))

# * Configuration files for these tests are located in test/config.
# * Create a test/config/database.yml based on the example file.

class TestDbxDriverMysql < Test::Unit::TestCase
  def test_default
    mysql = DBX::Driver::MySQL.new(database_config(:mysql))
    
    assert mysql.connect?
  end
  
  def test_databases
    mysql = DBX::Driver::MySQL.new(database_config(:mysql))
  
    database_names = mysql.database_names
    
    # Since there's no way to know what databases are defined here, simply
    # check that there's at least one. There's always a "mysql" database
    # defined, for instance.
  
    assert database_names.select { |d| d.is_a?(String) }.length > 0
    
    assert database_names.include?("mysql")

    assert_equal database_names, mysql.databases.collect { |name, database| database.name }
  end

  def test_create_and_drop_databases
    mysql = DBX::Driver::MySQL.new(database_config(:mysql))
    
    test_db_name = "__test_#{Time.now.to_i}"
    
    database = mysql.database(test_db_name)
    
    assert_equal nil, database
    
    database = mysql.database(test_db_name, :force => true)
    
    assert database
    assert_equal test_db_name, database.name

    assert_equal database, mysql.databases[test_db_name]
    assert_equal database, mysql.database(test_db_name)
    assert_equal database, mysql.database(test_db_name.to_sym)
    
    database.drop!
    
    assert_equal nil, mysql.databases[test_db_name]
    assert_equal nil, mysql.databases(:reload => true)[test_db_name]
    assert_equal nil, mysql.database(test_db_name.to_sym)
    
    database = mysql.databases.create(test_db_name, :force => true)

    assert database

    assert_equal database, mysql.databases[test_db_name]
    assert_equal database, mysql.database(test_db_name)
    assert_equal database, mysql.database(test_db_name.to_sym)

    mysql.databases.drop!(test_db_name)
    
    assert_equal nil, mysql.databases[test_db_name]
    assert_equal nil, mysql.databases(:reload => true)[test_db_name]
    assert_equal nil, mysql.database(test_db_name.to_sym)
  end

  def test_table_list
    mysql = DBX::Driver::MySQL.new(database_config(:mysql))
    
    test_db_name = "__test_#{Time.now.to_i}"
    
    database = mysql.database(test_db_name, :force => true)
    
    database.query("CREATE TABLE test1 (id INT AUTO_INCREMENT PRIMARY KEY)")
    
    database.drop!
  end
end
