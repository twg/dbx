require File.expand_path('helper', File.dirname(__FILE__))

class TestDbxSupport < Test::Unit::TestCase
  def test_symbolize_keys
    hash = {
      'a' => 'a',
      :b => :b,
      nil => 'nil'
    }
    
    expected = {
      :a => 'a',
      :b => :b,
      nil => 'nil'
    }
    
    assert_equal(expected, DBX::Support.symbolize_keys(hash))
  end

  def test_symbolize_keys_recursive
    hash = {
      'a' => {
        'b' => 'b'
      },
      'b' => 'b',
      'c' => [ 10 ]
    }
    
    expected = {
      :a => {
        :b => 'b'
      },
      :b => 'b',
      :c => [ 10 ]
    }
    
    assert_equal(expected, DBX::Support.symbolize_keys(hash))
  end
end
