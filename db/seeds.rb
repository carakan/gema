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

TipoSigno.create!(:nombre => 'Denominación', :sigla => 'Den.' )
TipoSigno.create!(:nombre => 'Figurativa', :sigla => 'Fig.' )
TipoSigno.create!(:nombre => 'Mixta', :sigla => 'Mix.' )
TipoSigno.create!(:nombre => 'Tridimensional', :sigla => 'Tri.' )
TipoSigno.create!(:nombre => 'Etiqueta', :sigla => 'Eti.' )
TipoSigno.create!(:nombre => 'Logotipo', :sigla => 'Log.' )
TipoSigno.create!(:nombre => 'Envase', :sigla => 'Env.' )
puts "Se han creado los tipos de signo base"

# Rake::Task["importar:clases"].execute
# No depende de Internet
clases = YAML.load_file(File.join(Rails.root, 'db/clases.yml'))
clases.each{ |attr| Clase.create!(attr) }
puts "Se han creado los clases base"

#TipoMarca.create!(:nombre => 'Denominación', :sigla => 'DN.')
TipoMarca.create!(:nombre => 'Marca Producto', :sigla => 'MP.')
TipoMarca.create!(:nombre => 'Marca Servicio', :sigla => 'MS.')
TipoMarca.create!(:nombre => 'Lema Comercial', :sigla => 'LC.')
TipoMarca.create!(:nombre => 'Nombre Comercial', :sigla => 'NC.')
TipoMarca.create!(:nombre => 'Rótulo Comercial', :sigla => 'RC.')
TipoMarca.create!(:nombre => 'Marca de Certificación', :sigla => 'MC.')
puts "Se han creado  los tipos de marca base"

#TipoMarca.create!(:nombre => 'Solicitud Marca', :sigla => 'SM.')
paises = YAML.load_file(File.join(Rails.root, 'db/paises.yml'))
paises.each{ |v| Pais.create!(v) }
puts "Se han creado los paises base"

marca_estados =
   {'pp' => 'Pendiente de presentación',
    'ppub' => 'Pendiente de publicación',
    'ppubno' => 'Pendiente de publicación/no observada',
    'ppubo' => 'Pendiente de publicación/observada',
    'ppubpdoc' => 'Pendiente de publicación/presentar documentación',
    'ppubl' => 'Pendiente de publicación/litigio',
    'pubpo' => 'Publicada/en periodo de oposición',
    'eopnd' => 'En oposición/pendiente notificación demanda',
    'per' => 'Pendiente de exámen de registrabilidad',
    'dipr' => 'Denegada inpugnación pendiente resolución',
    'dpi' => 'Denegada periodo de inpugnación',
    'rpecr' => 'Registrada/pendiente extención certificado de registro',
    'rpad' => 'Registrada/pendiente de aviso y despacho',
    'rad' => 'Registrada/avisada y despachada',
    'rpir' => 'Registrada/pendiente de intrucción renovación',
    'rppsr' => 'Registrada/pendiente presentación solicitud renovación',
    'rpcr' => 'Registrada pendiente de conceción renovación',
    'renpecr' => 'Renovada/pendiente de extensión certificado de renovación',
    'renpad' => 'Renovada/pendiente de aviso y despacho',
    'renad' => 'Renovada/avisada despachada',
    'c' => 'Caduca',
    'i' => 'Inactiva'}
marca_estados.each {|k, v| MarcaEstado.create(:abreviacion => k, :nombre => v) }
puts "Se han creado los estados base"

