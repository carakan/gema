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

  desc 'Importa los paises desde internet y los guarda en un archivo yaml'
  task :paises => :environment do
    require 'open-uri'
    n = Nokogiri::HTML(open('http://www.iso.org/iso/english_country_names_and_code_elements'))
    arr =[]
    n.css('table tr').each_with_index do |tr, ind|
      if ind > 0
        td = tr.css('td')
        if td.children.last.text.strip =~ /^[a-z].*/i
          arr << { :nombre => td.children.first.text.strip, 
            :codigo => td.children.last.text.strip }
        end
      end
    end

    f = File.new(File.join(Rails.root, 'db/paises.yml'), 'w+' )
    puts arr.to_yaml
    f.write(arr.to_yaml)
    f.close
  end

end

namespace :db do
  desc 'Crea todo con datos iniciales'
  task :inicial => :environment do
    Rake::Task["db:drop"].execute
    Rake::Task["db:create"].execute
    Rake::Task["db:migrate"].execute
    Rake::Task["db:seed"].execute
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
    f = FasterCSV.read(Rails.root.to_s + '/doc/archivos/BD_ORPAN.csv', :headers => true)
    f.each do |r|
      m = Marca.new(:nombre => r['nombre'], :clase_id => r['clase_id'] )
      m.save(false)
    end
  end
end
