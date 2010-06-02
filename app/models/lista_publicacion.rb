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
      datos.each{ |dato| 
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
    regmarca = /[^\w\sÑñáéíóú()]/i
    datos = []
    dato = {}
    
    n.css("div>div").each do |div|
      text = div.text.gsub(regexp, '')

      if text == 'NUMERO DE PUBLICACION'
        unless dato.empty?
          datos.push( dato )
          dato = {}
        end
        dato[:sm] = div.next_element.text.gsub(regexp, '')
      end

      if text == 'NOMBRE DE LA MARCA'
        t = div.previous_element.text
        t["\302\240"] = "" # Limpieza del &nbsp; generado en el HTML
        dato[:nombre] = t
      end

      if text == 'NUMERO DE SOLICITUD'
        i+= 1
        dato[:sm] = div.next_element.text.gsub(regexp, '') 
      end

      if text == 'CLASE INTERNACIONAL'
        i+= 1
        dato[:clase_int] = div.next_element.text.gsub(regexp, '') 
      end

      #if text == 'DIRECCION DEL TITULAR'
      #end
      #if text == 'NOMBRE DEL TITULAR'
      #end
      #if text == 'PAIS DEL TITULAR'
      #end
      #if text == 'NOMBRE DEL APODERADO'
      #end

      i += 1
    end

    datos.push(dato)

    datos

  end

end
