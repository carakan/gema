source 'http://rubygems.org'

gem 'rails', '3.0.5'

gem 'mysql2', "0.2.6"
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
gem 'will_paginate','3.0.pre2'
gem 'nokogiri'
gem 'forgery'
gem 'zip'
gem 'spreadsheet'
gem 'google-spreadsheet-ruby'
gem 'roo'
gem 'paperclip'
gem 'prawn'
gem 'less'
gem 'devise', '1.2.1'
gem 'simple_form', '1.3.1'
gem "meta_search"
gem 'warden', '1.0.3'
gem 'show_for'
gem "cocoon", '1.0.3'

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

