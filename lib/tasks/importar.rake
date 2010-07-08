require 'open-uri'


namespace :importar do
  desc "Importa todas las clases desde internet"
  task :clases => :environment do
    n = Nokogiri::HTML( open('http://www.marcasenelmundo.com.ar/clasificacion%20de%20niza.htm') )
    clases = []
    n.css('h1').each{ |h1| clases << h1 if h1.text =~ /Clase/ }
    clases.each do |clase|
      c = Clase.new(:nombre => clase.text, :codigo => clase.text.gsub(/[^0-9]/,'').to_i )
      c.descripcion = clase.next_element.text.gsub(/^[^a-zñÑáéíóú09\s(),"\n\r]+$/i, '').squish
      if c.save
        puts "Se importo #{c.nombre}, #{c.codigo}"
      else
        puts "Error al importar #{c.nombre}, #{c.codigo}"
      end
    end
  end

  desc 'Descarga de http://www.senapi.gob.bo/ los archivos de publicacion'
  task :descargar_publicaciones do
    require 'mechanize'
    require 'ruby-debug'
    #require 'oper-uri'
    dir = File.join( File.dirname(__FILE__), 'archivos', 'temp', 'senapi')
    Dir.chdir(dir)

    m = Mechanize.new
    m.get('http://www.senapi.gob.bo/publicaciones.asp') do |page|

      page.links.each do |link|
        if link.text =~ /Signos D/
          system("wget http://#{page.uri.host}/#{link.href}")
        end
      end
    end
  end

end

namespace :datos do
  desc 'Crea datos de demo'
  task :demo => :environment do
    Agente.create!(:nombre => 'Karina Luna')
    Agente.create!(:nombre => 'Eddy Sanchez')
    Agente.create!(:nombre => 'Marco Arcienaga')
    Agente.create!(:nombre => 'Amaru Barroso')
    Agente.create!(:nombre => 'Lucas Estrella')
    Agente.create!(:nombre => 'Violeta Barroso')
  end

  desc 'Importa solo los nombres de la base de datos de Orpan'
  task :marcas => :environment do
    require 'fastercsv'
    UsuarioSession.current_user = Usuario.first
    f = FasterCSV.read('', :headers => true)
    f.each do |r|
      m = Marca.new(:nombre => r.field('nombre'), :clase_id => r.field('clase_id') )
      m.save(false)
    end
  end
end
