require 'open-uri'

task :jejejejeje do
  puts "Hola"
end

namespace :importar do
  desc "Importa todas las clases desde internet"
  task :clases => :environment do
    n = Nokogiri::HTML( open('http://www.marcasenelmundo.com.ar/clasificacion%20de%20niza.htm') )
    clases = []
    n.css('h1').each{ |h1| clases << h1 if h1.text =~ /Clase/ }
    clases.each do |clase|
      c = Clase.new(:nombre => clase.text, :codigo => clase.text.gsub(/[^0-9]/,'').to_i )
      c.descripcion = clase.next_element.text.gsub(/[^a-zñÑáéíóú09\s(),"\n\r]+/i, '').squish
      if c.save
        puts "Se importo #{c.nombre}, #{c.codigo}"
      else
        puts "Error al importar #{c.nombre}, #{c.codigo}"
      end
    end
  end
end
