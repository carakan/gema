require 'rubygems'
require 'active_support'
require 'active_support/test_case'

ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'

def load_schema
  config = YAML::load(IO.read)
end
