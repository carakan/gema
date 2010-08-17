# desc "Explaining what the task does"
# task :rorol do
#   # Task goes here
# end
namespace :db do
  namespace :migrate do  
    desc "Correr migraciones para rorol" 
    task :rorol => :environment do
      ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true 
      ActiveRecord::Migrator.migrate("vendor/plugins/rorol/lib/db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)  
      Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby  
    end 
  end
end 
