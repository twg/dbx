module DBX
  autoload(:Driver, 'dbx/driver')
  autoload(:Entity, 'dbx/entity')
  autoload(:Support, 'dbx/support')
  
  class InvalidAdapterException < Exception; end
  
  def self.version
    @version ||= File.read(File.expand_path(File.join('..', 'VERSION'), File.dirname(__FILE__))).chomp
  end
  
  def self.connect(options)
    case (options['adapter'])
    when 'mysql2'
      DBX::Driver::MySQL.new(options)
    when 'pg'
      DBX::Driver::Postgres.new(options)
    else
      raise InvalidAdapterException, "Unknown adapter type #{options[:adapter].inspect}"
    end
  end
end
