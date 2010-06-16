# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
Usuario.create!(:nombre => 'Admin', :login => 'admin', :password => 'demo123' )

TipoMarca.create!(:nombre => 'Denominación', :sigla => 'Den.' )
TipoMarca.create!(:nombre => 'Figurativa', :sigla => 'Fig.' )
TipoMarca.create!(:nombre => 'Mixta', :sigla => 'Mix.' )
TipoMarca.create!(:nombre => 'Tridimensional', :sigla => 'Tri.' )

Rake::Task["importar:clases"].execute
