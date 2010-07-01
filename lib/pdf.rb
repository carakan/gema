module PDF

  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods
    attr_accessor :pdf_path, :archivo_pdf, :css_selector, :lista, :posicion, :metodo

    REGEXP = /[^\w\sÑñáéíóú]/i
    REGMARCA = /[^\w\sÑñáéíóú()]/i
    REGBLANK = /\302\240/

    def acts_as_pdftohtml(pdf, css, metodo, lista)
      @pdf_path = File.join(Rails.root, pdf)
      @css_selector = css
      @lista = lista
      @metodo = metodo
      @posicion = 0 # Posicion en la lista de divs (elementos) que se encuentra
    end

    # metodo que se encarga de la importacion del archivo
    def importar_pdf(archivo)
      pdf = preparar_pdf(archivo)
      convertir_pdf(pdf)
      
      dir = File.dirname(pdf)
      Dir.glob("#{dir}/*.html").each do |html|
        arr = extraer_datos_html(html)
        # Metodo utilizado para actualiar en la clase
        arr.each{ |params| send(@metodo, params) }
      end

      borrar_directorio_pdf(pdf)
    end

    # Elimina el directorio en el cual se creo el archivo
    def borrar_directorio_pdf(pdf)
      FileUtils.remove_dir( File.dirname(pdf) )
    end

    # Extraccion de imagen
    # Para la extraccion de la imagen es necesario saber la posicion 
    # del div con 'NOMBRE DE LA MARCA' y restarle 7
    # x = 417
    # y = div[:style].gsub(/.*(top:[0-9]+).*/, '\1').gsub(/top:/, '').to_i - 7
    # system("convert #{img} -crop 130x130+417+#{y} prueba.png")
    # system("convert #{img} -crop 130x130+417+#{y} prueba.png")

    def convertir_pdf(pdf)
      raise "Error al convertir #{pdf} de pdf a html" unless system("pdftohtml -c #{pdf}")
    end


    # Busca los elementos de acuerod al formato
    # Es necesario validar cual es el primer dato que se envia ya que
    # debido a que los tags son una lista puede realizarse una busqueda
    # en otro contexto, y sobrepasarse al primero de la lista 2 veces
    def extraer_datos_html(html)
      n = Nokogiri::HTML( File.open(html) )
      @posicion = 0
      arr = []
      divs = n.css(@css_selector)
      @fin = false

      divs.each_with_index do |div, i| 
        hash = {}
        @lista.each do |key, desp|
          primero = @lista.first[0] == key
          hash[key] = buscar_por_nombre(divs, key, desp, primero)
          if hash[key] == false
            hash.delete(key)
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
        return false if text == @lista.first[0] and !primero

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
  end

end
