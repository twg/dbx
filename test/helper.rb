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
      YAML.load(
        File.open(
          File.expand_path('config/database.yml', File.dirname(__FILE__))
        )
      )
    end
    
    @test_config and Hash[
      @test_config[section.to_s].collect do |k, v|
        [ k.to_sym, v ]
      end
    ]
  end
end
