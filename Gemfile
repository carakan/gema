source 'http://rubygems.org'

gem 'rails', '3.0.3'

gem 'mysql2' #, '2.8.1'
if RUBY_VERSION == "1.8.7"
  gem 'ruby-debug'
  gem 'fastercsv'
  gem 'hashie'
elsif RUBY_VERSION == "1.9.2"
  gem 'ruby-debug19', :require => "ruby-debug"
  gem 'unicode_utils'
end

gem "nifty-generators"
gem "haml"
gem 'formtastic'
gem 'will_paginate'
gem 'nokogiri'
gem 'forgery'
gem 'zip'
gem 'spreadsheet'
gem 'google-spreadsheet-ruby'
gem 'roo'
gem 'paperclip'
gem 'prawn'
gem 'less'
gem 'devise'
gem 'simple_form'
gem "meta_search"
gem 'warden'

group :development do
  gem "nifty-generators"
end

group :test do
  gem 'rspec-rails'
  gem 'steak'
  gem 'capybara'
  gem 'mocha'
  gem 'spork'
end
