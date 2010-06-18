# eoncoding: utf-8
class ListaPublicacion < Marca

  validates_presence_of :tipo_marca_id
  
  def self.importar(archivo, gaceta = '')
    case File.extname(archivo.original_filename.downcase)
      when ".pdf" 
        importar_pdf(archivo)
      when ".xls" 
        importar_excel(archivo)
    end
  end

  # Realiza la importación de un PDF
  def self.importar_pdf(archivo)

    pdf_path = preparar_pdf2html(archivo)

    fecha_imp = DateTime.now.strftime("%Y-%m-%d %H:%I:%S")

    # Ejecutar comando
    %x[pdftohtml -c #{ pdf_path }]
    raise "Existio un error al importar intente de nuevo" unless $?.success?

    # Iterar todos los archivos html
    Dir.glob("#{ File.dirname(pdf_path) }/*.html").each do |html|
      datos = extraer_datos_html(html)

      datos.each{ |params|
        actualizar_datos(params, fecha_imp)
      }
    end

    FileUtils.remove_dir(dir)
  end

  def self.importar_excel(archivo)
  end

private
  def preparar_pdf2html(archivo)
    dir = File.join( Rails.root, 'archivos/temp/pdf/', Time.now.to_i.to_s )
    FileUtils.mkdir(dir)
    pdf_path = "#{ dir }/#{ File.basename( archivo.path ) }"
    FileUtils.mv( archivo.path, pdf_path )
    pdf_path
  end

  # Busca o actualiza los datos cargados a traves de la importacion
  def self.actualizar_datos(params, fecha_imp)

  end

  # Busca los elementos de acuerod al formato
  def self.extraer_datos_html(html, formato)
    n = Nokogiri::HTML( File.open(html) )
    i = 1
    numero = 0
    regexp = /[^\w\sÑñáéíóú]/i
    regmarca = /[^\w\sÑñáéíóú()]/i
    regblank = /\302\240/
    datos = []
    dato = {}
    
    n.css("div>div").each do |div|
      text = div.text.gsub(regexp, '').strip.gsub(regblank, '')

      if text == 'NUMERO DE PUBLICACION'
        unless dato.empty?
          datos.push( dato )
          dato = { :titular => {}, :agente => {} }
        end
        dato[:numero_publicacion] = div.next_element.text.gsub(regexp, '').gsub(regblank, '')
      end

      if text == 'NOMBRE DE LA MARCA'
        dato[:nombre] = div.previous_element.text.gsub( /\302\240/, '' )
      end

      if text == 'NUMERO DE SOLICITUD'
        i+= 1
        dato[:numero_solicitud] = div.next_element.text.gsub(regexp, '').gsub(regblank, '')
      end

      if text == 'CLASE INTERNACIONAL'
        i+= 1
        dato[:clase_id] = div.next_element.text.gsub(regexp, '').gsub(regblank, '') 
      end

      if text == 'DIRECCION DEL TITULAR'
        data[:titular][:direccion] = ''
      end
      if text == 'NOMBRE DEL TITULAR'
      end
      if text == 'PAIS DEL TITULAR'
      end
      if text == 'NOMBRE DEL APODERADO'
      end

      i += 1
    end

    datos << dato

    datos

  end

  def self.coordenadas(elem, args)
    text = ""
    unless args.is_a? Array
      arr = [args]
    end

    arr.each do |pos|
      
    end
  end

  def self.buscar_siguiente(pos, i)

  end

  def self.buscar_anterior(pos, i)
  end

end
