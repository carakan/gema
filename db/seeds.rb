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

TipoSigno.create!(:nombre => 'Marca Denominativa', :sigla => 'MD'             ) { |t| t.id = 1 }
TipoSigno.create!(:nombre => 'Marca Figurativa', :sigla => 'MF'               ) { |t| t.id = 2 }
TipoSigno.create!(:nombre => 'Marca Mixta', :sigla => 'MM'                    ) { |t| t.id = 3 }
TipoSigno.create!(:nombre => 'Marca Tridimensional', :sigla => 'MT'           ) { |t| t.id = 4 }
TipoSigno.create!(:nombre => 'Nombre Comercial Denominativo', :sigla => 'NCD' ) { |t| t.id = 5 }
TipoSigno.create!(:nombre => 'Nombre Comercial Mixto', :sigla => 'NCM'        ) { |t| t.id = 6 }
TipoSigno.create!(:nombre => 'Lema Comercial', :sigla => 'LC'                 ) { |t| t.id = 7 }
TipoSigno.create!(:nombre => 'Otro', :sigla => 'OT'                           ) { |t| t.id = 8 }
puts "Se han creado los tipos de signo base"

# Rake::Task["importar:clases"].execute
# No depende de Internet
clases = YAML.load_file(File.join(Rails.root, 'db/clases.yml'))
clases.each{ |attr| Clase.create!(attr) }
puts "Se han creado los clases base"

#TipoMarca.create!(:nombre => 'Denominación', :sigla => 'DN.')
TipoMarca.create!(:nombre => 'Marca Producto', :sigla => 'MP'         ) { |t| t.id = 1 }
TipoMarca.create!(:nombre => 'Marca Servicio', :sigla => 'MS'         ) { |t| t.id = 2 }
TipoMarca.create!(:nombre => 'Marca Colectiva', :sigla => 'MCO'       ) { |t| t.id = 3 }
TipoMarca.create!(:nombre => 'Marca de Certificación', :sigla => 'MCE') { |t| t.id = 4 }
TipoMarca.create!(:nombre => 'Otro', :sigla => 'OT'                   ) { |t| t.id = 5 }
puts "Se han creado  los tipos de marca base"

#TipoMarca.create!(:nombre => 'Solicitud Marca', :sigla => 'SM.')
paises = YAML.load_file(File.join(Rails.root, 'db/paises.yml'))
paises.each{ |v| Pais.create!(v) }
puts "Se han creado los paises"

YAML.load_file(File.join(Rails.root, 'db/marca_estados.yml')).each do |v|
  MarcaEstado.create!(v)
end
puts "Se ha creado marca estados"
