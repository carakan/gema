module ModMarca::PDF

  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods
    attr_accessor :pdf_dir, :pdf_archivo, :pdf_parametros, 
      :css_selector, :posicion, :lista_seleccionada, :seccion

    REGEXP = /[^\w\sÑñáéíóú]/i
    REGMARCA = /[^\w\sÑñáéíóú()]/i
    REGBLANK = /\302\240/

    # metodo que se encarga de la importacion del archivo y utiliza el metodo
    # "crear_instancia_pdf" que se encuentra en lib/mod_marca/lista_publicacion.rb
    #   @param TmpFile archivo
    #   @param String yaml
    def importar_pdf(*args)
      prepara_importacion_pdf(args)
      lista_seleccionada = pdf_parametros['DENOMINATIVAS']

      # Transaccion para la importacion de datos
      transaction do |t|
        Dir.glob("#{pdf_dir}/*.html").each do |html|
          arr = extraer_datos_html(html)
          # Metodo utilizado para actualizar en la clase
          arr.each do |params|
            # crear_instancia_pdf  se encuentra en el archivo lista_publicacion
            # lib/mod_marca/lista_publicacion.rb
            m = crear_marca_pdf(params)
            m.save
          end
        end
      end

      borrar_directorio_pdf(pdf)
    end

    # Realiza la busqueda de seccion dependiendo de la hoja
    #   @param Array divs # Lista de objetos Nokogiri
    #
    def buscar_seccion(divs)
      divs.each do |div|
        case div.text.gsub(REGBLANK, '').strip
          when 'DENOMINATIVAS'
            self.seccion = 'DENOMINATIVAS'
          when 'FIGURATIVAS'
            self.seccion = 'FIGURATIVAS'
            return
        end
      end
    end

    # Prepara los datos para realizar la importación de un PDF
    def prepara_importacion_pdf(args)
      options = args.extract_options! || {}

      pdf_archivo = preparar_pdf(args[0])
      convertir_pdf(pdf_archivo)

      pdf_parametros = YAML.load_file(args[0])
      pdf_dir = File.dirname(pdf)

      css_selector = options[:css_selector] || 'div>div'
    end


    # Elimina el directorio en el cual se creo el archivo
    def borrar_directorio_pdf(pdf)
      FileUtils.remove_dir( File.dirname(pdf) )
    end

    # Extrae datos de una hoja HTML de acuerdo al formato que se le indica
    # Es necesario validar cual es el primer dato que se envia ya que
    # debido a que los tags son una lista puede realizarse una busqueda
    # en otro contexto, y sobrepasarse al primero de la lista 2 veces
    #   @param String html
    #   @param Array lista
    #   @return Array # Retorna un array con varios Hash, en una hoja hay varias marcas
    def extraer_datos_html(html)
      n = Nokogiri::HTML( File.open(html) )
      posicion = 0
      arr = []
      divs = n.css(css_selector)
      @fin = false

      divs.each_with_index do |div, i| 
        hash = {}
        lista_seleccionada.each do |key, desp|
          primero = lista_seleccionada.first[0] == key
          hash[key] = buscar_por_nombre(divs, key, desp, primero)
          if hash[key] == false
            hash.delete(key)
            buscar_seccion(divs)
            break
          end
          hash['imagen'] = extraer_imagen
        end
        arr << hash
        #debugger unless hash['']

        break if @posicion == (divs.size - 1)
      end
      arr.delete_if{ |h| h.blank? }

      arr
    end

    # Extraccion de imagen
    # Para la extraccion de la imagen es necesario saber la posicion 
    # del div con 'NOMBRE DE LA MARCA' y restarle 7
    # x = 417
    # y = div[:style].gsub(/.*(top:[0-9]+).*/, '\1').gsub(/top:/, '').to_i - 7
    # system("convert #{img} -crop 130x130+417+#{y} prueba.png")
    # system("convert #{img} -crop 130x130+417+#{y} prueba.png")
    # Realiza el crop de imagenes para extraer el logo
    def extraer_imagen

    end

    # Busca en la lista de tags
    # @param element
    # @param String nombre
    # @param Integer pos
    # @param [true, false] Ayuda a identificar si es el primero de la lista
    def buscar_por_nombre(elements, nombre, desplazar, primero)
      # Identifica si es el primer elemento
      (posicion..(elements.size - 1)).each do |i|
        text = elements[i].text.gsub(REGBLANK, '').strip
        # Retorna false si es que ya esta buscando en otro contenido
        return false if text == @lista_seleccionada.first[0] and !primero

        if text == nombre
          # Importante
          @posicion = i + 1
          if desplazar > 0
            @current_elem = elem = buscar_siguiente(elements[i], desplazar)
          else
            @current_elem = elem = buscar_anterior(elements[i], desplazar)
          end
        end

        return elem.text.gsub(REGBLANK, ' ').squish unless elem.nil?

        if (elements.size - 1) == i
          @posicion = i
          return false
        end

      end

    end

    def buscar_siguiente(element, pos)
      if pos == 0
        element
      else
        buscar_siguiente(element.next_element, pos - 1)
      end
    end

    def buscar_anterior(element, pos)
      if pos == 0
        element
      else
        buscar_anterior(element.previous_element, pos + 1)
      end
    end

    # Prepara el archivo subido y lo copia en un directorio
    # @param Rack:TempFile
    # @return String
    def preparar_pdf(archivo)
      raise "Error, el archivo selecionado no es un PDF" unless archivo.content_type == 'application/pdf'

      raise "Error, el directorio \"#{pdf_path}\" al cual desea subir" unless File.exists?(pdf_path)

      dir = File.join( pdf_path, Time.now.to_i.to_s )
      FileUtils.mkdir(dir)
      path = "#{ dir }/#{ archivo.original_filename }"
      FileUtils.mv( archivo.path, path )
      path
    end

    # Convierte un PDF en archivos de HTML usando pdftohtml "http://pdftohtml.sourceforge.net/"
    def convertir_pdf(pdf)
      raise "Error al convertir #{pdf} de pdf a html" unless system("pdftohtml -c #{pdf}")
    end
  end

end
