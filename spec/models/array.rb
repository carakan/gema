# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

# Class to test order
class TestClass
  attr_accessor :pos, :name
end

arr = [
  {:pos => 1, :name => 'sartan'},
  {:pos => 1, :name => 'pachan'},
  {:pos => 1, :name => 'mecan'},
  {:pos => 1, :name => 'lujan'},
  {:pos => 1, :name => 'sartan'},
  {:pos => 1, :name => 'sartan'},
  {:pos => 1, :name => 'sartan'},
  {:pos => 1, :name => 'sartan'},
  {:pos => 1, :name => 'acusan'},
  {:pos => 1, :name => 'mecachan'},
  {:pos => 1, :name => 'zartan'},
  {:pos => 1, :name => 'busan'},
  {:pos => 1, :name => 'agusan'},
  {:pos => 1, :name => 'milan'}
]

describe Array do
  before(:each) do
    
  end
end
