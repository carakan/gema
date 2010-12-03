# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

TipoSigno.create!(:nombre => 'Marca Denominativa', :sigla => 'MD' )
TipoSigno.create!(:nombre => 'Marca Figurativa', :sigla => 'MF' )
TipoSigno.create!(:nombre => 'Marca Mixta', :sigla => 'MM' )
TipoSigno.create!(:nombre => 'Marca Tridimensional', :sigla => 'MT' )
TipoSigno.create!(:nombre => 'Nombre Comercial Denominativo', :sigla => 'NCD' )
TipoSigno.create!(:nombre => 'Nombre Comercial Mixto', :sigla => 'NCM' )
TipoSigno.create!(:nombre => 'Lema Comercial', :sigla => 'LC' )
TipoSigno.create!(:nombre => 'Otro', :sigla => 'OT' )
puts "Se han creado los tipos de signo base"

# Rake::Task["importar:clases"].execute
# No depende de Internet
clases = YAML.load_file(File.join(Rails.root, 'db/clases.yml'))
clases.each{ |attr| Clase.create!(attr) }
puts "Se han creado los clases base"

#TipoMarca.create!(:nombre => 'Denominación', :sigla => 'DN.')
TipoMarca.create!(:nombre => 'Marca Producto', :sigla => 'MP')
TipoMarca.create!(:nombre => 'Marca Servicio', :sigla => 'MS')
TipoMarca.create!(:nombre => 'Marca Colectiva', :sigla => 'MCO')
TipoMarca.create!(:nombre => 'Marca de Certificación', :sigla => 'MCE')
TipoMarca.create!(:nombre => 'Otro', :sigla => 'OT')
puts "Se han creado  los tipos de marca base"

#TipoMarca.create!(:nombre => 'Solicitud Marca', :sigla => 'SM.')
paises = YAML.load_file(File.join(Rails.root, 'db/paises.yml'))
paises.each{ |v| Pais.create!(v) }
puts "Se han creado los paises"

YAML.load_file(File.join(Rails.root, 'db/marca_estados.yml')).each do |v|
  MarcaEstado.create!(v)
end
puts "Se ha creado marca estados"
