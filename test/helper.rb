require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'dbx'

require 'yaml'

class Test::Unit::TestCase
  def database_config(section)
    @test_config ||= begin
      config = 
        YAML.load(
          File.open(
            File.expand_path('config/database.yml', File.dirname(__FILE__))
          )
        )
      
      config and DBX::Support.symbolize_keys(config)
    end
    
    @test_config[section]
  end
end
