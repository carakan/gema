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

    Titular.create!(:nombre => 'Eddy Sanches')
    Titular.create!(:nombre => 'Alejandra Helguero')
    Titular.create!(:nombre => 'Marco Arcienaga')

    Usuario.create!(:nombre => 'Boris Barroso', :login => 'boris', :password => 'demo123', :password_confirmation => 'demo123', :rol => 'genrente')
    Usuario.create!(:nombre => 'Alejandra Helguero', :login => 'alejandra', :password => 'demo123', :password_confirmation => 'demo123', :rol => 'genrente')

  end

  desc 'Importa solo los nombres de la base de datos de Orpan'
  task :marcas_csv => :environment do
    require 'fastercsv'
    UsuarioSession.current_user = Usuario.first
    Dir.chdir("#{Rails.root}/doc/archivos")
    system("tar xjf OrpanPropia_7-8-2010_1.csv.tar.bz2")
    archivo = 'OrpanPropia_7-8-2010_1.csv'

    f = FasterCSV.read( archivo, :headers => true) # :col_sep => ','
    fila = 2
    f.each do |r|
      m = Marca.new(
        :nombre => r['nombre'], 
        :clase_id => r['clase_id'],
        :tipo_signo_id => r['tipo_signo_id'],
        :tipo_marca_id => r['tipo_marca_id'],
        :clase_id => r['clase_id'],
        :numero_solicitud => r['numero_solicitud'],
        :numero_registro => r['numero_registro'],
        :fecha_registro => r['fecha_registro'],
        :numero_renovacion => r['numero_renovacion'],
        :numero_publicacion => r['numero_publicacion'],
        :numero_gaceta => r['numero_gaceta'],
        :fecha_publicacion => r['fecha_publicacion'],
        :activa => r['activa'].to_i == 1 ? true : false,
        :propia => true,
        :parent_id => 0
      )
      begin
        m.save(false)
      rescue
        puts "Error en fila #{fila}"
      end
      fila += 1
    end

    File.delete( archivo )
  end

  desc "Ejecuta un SQL para importar las marcas"
  task :marcas_sql => :environment do
    Dir.chdir("#{Rails.root}/doc/archivos")
    system("bunzip2 marcas.sql.bz2 -k")
    archivo = File.read( 'marcas.sql' )
    archivo.split(";").each do |sql|
      ActiveRecord::Base.connection.execute( sql )
    end

    File.delete( 'marcas.sql' )
  end


  desc "Borra marcas, representantes y adjuntos"
  task :borrar_imp => :environment do
    Importacion.destroy_all
    #Marca.destroy_all # No es necesario por que importacion :dependent => :destroy
    Representante.destroy_all
    Adjunto.destroy_all
  end

  desc "Adiciona datos para poder comparar en iportaciones"
  task :marcas_prueba => :environment do
    UsuarioSession.current_user = Usuario.first
    Marca.create!(:nombre => 'VERDE VIV', :estado => 'sm', :numero_solicitud => '3492-2009',  :tipo_signo_id => 1,
                  :estado_fecha => '2009-09-01', :apoderado => 'Fabiana Cunioli Pa', :clase_id => 38, :propia => true)
  end
end
