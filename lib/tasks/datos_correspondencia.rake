# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
require 'faker'
require 'rubygems'
require 'mysql2'
#require 'fastercsv'

namespace :datos_correspondencia do
db = Mysql::new(“localhost”, “root”, “demo123”, “gema_development”)
i=1
while i < 50 do
c=Faker::Name.name
c.gsub(“‘”,”")
sql = “INSERT INTO datas VALUES(#{i},’#{c}’,’0′,’0′);”db.query(sql)
i+=1
end
end
