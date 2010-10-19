source 'http://rubygems.org'

gem 'rails' #, '3.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

#gem 'sqlite3-ruby', :require => 'sqlite3'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
gem 'mysql2' #, '2.8.1'
if RUBY_VERSION == "1.8.7"
  gem 'ruby-debug'
  gem 'fastercsv'
elsif RUBY_VERSION == "1.9.2"
  gem 'ruby-debug19'
  gem 'unicode_utils'
end

gem 'formtastic'
gem 'will_paginate', '~> 3.0.pre2'
gem 'nokogiri'
gem 'forgery'
gem 'zip'
gem 'spreadsheet'
gem 'google-spreadsheet-ruby'
gem 'roo'
gem 'paperclip'
gem 'prawn', '0.10.2'
gem 'less'
gem 'devise'
gem 'simple_form'
#, :git => 'git://github.com/sandal/prawn.git'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
group :test do
  gem 'rspec-rails'
  gem 'steak', '>= 1.0.0.rc.1'
  gem 'capybara'
end
