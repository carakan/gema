# eoncoding: utf-8
class ListaPublicacion < Marca
  
  def self.importar(archivo)
    case File.extname(archivo.original_filename.downcase)
      when ".pdf" importar_pdf(archivo)
      when ".xls" importar_excel(archivarchivoo)
    end
  end

  # Realiza la importación de un PDF
  def self.importar_pdf(archivo)
    dir = File.join( Rails.root, 'archivos/temp/pdf/', Time.now.to_i.to_s )
    FileUtils.mkdir(dir)
    pdf_path = "#{ dir }/#{ File.basename( archivo.path ) }"
    FileUtils.mv( archivo.path, pdf_path )

    %x[pdftohtml -c #{ pdf_path }]
    raise "Existio un error al importar intente de nuevo" unless $?.success?

    # Iterar todos los archivos html
    Dir.glob("#{ File.dirname(pdf_path) }/*.html").each do |html|
      datos = extraer_datos_html(html)
      debugger
      datos.each{ |dato| 
        m = Marca.new(dato)
        if m.save
        else
        end
      }
    end

    FileUtils.remove_dir(dir)
  end


  def self.importar_excel(archivo)
  end

protected
  def self.extraer_datos_html(html)
    n = Nokogiri::HTML( File.open(html) )
    i = 1
    numero = 0
    regexp = /[^\w\sÑñáéíóú]/i
    datos = []
    dato = {}
    
    n.css("div>div").each do |div|
      if div.text == 'NUMERO DE PUBLICACION'
        unless dato.empty?
          datos.push( dato )
          dato = {}
        end
        pos = i + 1
        dato[:sm] = n.css("div>div:eq(#{pos})").text.gsub(regexp, '')
      end
      if div.text == 'NOMBRE DE LA MARCA'
        pos = i - 1
        dato[:nombre] = n.css("div>div:eq(#{pos})").text.gsub(regexp, '') + "\n"
      end
      if div.text == 'DIRECCION DEL TITULAR'
        pos = i + 1
        #txt <<  'Dir tit: ' + n.css("div>div:eq(#{pos})").text.gsub(regexp, '') + "\n"
      end
      if div.text == 'NOMBRE DEL TITULAR'
        pos = i - 1
        #txt <<  'Num tit: ' + n.css("div>div:eq(#{pos})").text.gsub(regexp, '') + "\n"
      end
      if div.text == 'PAIS DEL TITULAR'
        pos = i + 1
        pos2 = i + 2
        #txt <<  'Pais tit: ' + n.css("div>div:eq(#{pos2})").text.gsub(regexp, '') + "\n"
      end
      if div.text == 'NOMBRE DEL APODERADO'
        pos = i + 1
        #txt <<  'Nom Tit: ' + n.css("div>div:eq(#{pos})").text.gsub(regexp, '') + "\n"
      end
      if div.text == 'CLASE INTERNACIONAL'
        pos = i + 1
        dato[:clase_id] = n.css("div>div:eq(#{pos})").text.gsub(regexp, '' ) + "\n"
      end

      i += 1
    end

    datos.push(dato)

    datos

  end

end
