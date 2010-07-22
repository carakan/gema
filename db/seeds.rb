# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
Usuario.create!(:nombre => 'Admin', :login => 'admin', :password => 'demo123', :password_confirmation => 'demo123' )

TipoSigno.create!(:nombre => 'Denominación', :sigla => 'Den.' )
TipoSigno.create!(:nombre => 'Etiqueta', :sigla => 'Eti.' )
TipoSigno.create!(:nombre => 'Mixta', :sigla => 'Mix.' )
TipoSigno.create!(:nombre => 'Tridimensional', :sigla => 'Tri.' )

# Rake::Task["importar:clases"].execute
# No depende de Internet
clases = YAML.load_file(File.join(Rails.root, 'db/clases.yml'))
clases.each{ |attr| Clase.create!(attr) }

#TipoMarca.create!(:nombre => 'Denominación', :sigla => 'DN.')
TipoMarca.create!(:nombre => 'Marca Producto', :sigla => 'MP.')
TipoMarca.create!(:nombre => 'Marca Servicion', :sigla => 'MS.')
TipoMarca.create!(:nombre => 'Lema Comercial', :sigla => 'LC.')
TipoMarca.create!(:nombre => 'Nombre Comercial', :sigla => 'NC.')
TipoMarca.create!(:nombre => 'Rótulo Comercial', :sigla => 'RC.')
#TipoMarca.create!(:nombre => 'Solicitud Marca', :sigla => 'SM.')
paises = YAML.load_file(File.join(Rails.root, 'db/paises.yml'))
paises.each{ |v| Pais.create!(v) }
