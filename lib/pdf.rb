module PDF

  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods
    attr_accessor :pdf_path, :archivo_pdf, :css_selector, :lista, :posicion, :metodo

    REGEXP = /[^\w\sÑñáéíóú]/i
    REGMARCA = /[^\w\sÑñáéíóú()]/i
    REGBLANK = /\302\240/

    def acts_as_pdftohtml(pdf, css, metodo, lista, primer_identificador)
      @pdf_path = File.join(Rails.root, pdf)
      @css_selector = css
      @lista = lista
      @metodo = metodo
      @primer_identificador = primer_identificador
      @posicion = 0 # Posicion en la lista de divs (elementos) que se encuentra
    end

    # metodo que se encarga de la importacion del archivo
    def importar_pdf(archivo)
      pdf = preparar_pdf(archivo)
      convertir_pdf(pdf)
      
      dir = File.dirname(pdf)
      Dir.glob("#{dir}/*.html").each do |html|
        extraer_datos_html(html)

        # Metodo utilizado para actualiar en la clase
        arr.each{ |params| send(@metodo, params) }
      end
      
    end

    def convertir_pdf(pdf)
      raise "Error al convertir #{pdf} de pdf a html" unless system("pdftohtml -c #{pdf}")
    end


    # Busca los elementos de acuerod al formato
    def extraer_datos_html(html)
      n = Nokogiri::HTML( File.open(html) )
      arr = []
      divs = n.css(@css_selector)
      @fin = false

      while @fin == false
        h = {}
        @recorridos = []
        @lista.each do |v|
          k, pos = v
          h[k] = buscar_por_nombre(divs, k, pos)
        end
        arr << h
      end
    end

    # Busca en la lista de tags
    # @param element
    # @param String nombre
    # @param pos
    def buscar_por_nombre(elements, nombre, desplazar)
      (posicion..elements.size).each do |i|
        text = elements[i].text.gsub(REGBLANK, '').strip

        if text == nombre
          @recorridos << nombre
          # Importante
          @posicion = i
          if desplazar > 0
            return buscar_siguiente(elements[i], desplazar).gsub(REGBLANK, '')
          else
            return buscar_anterior(elements[i], desplazar).gsub(REGBLANK, '')
          end
        end
      end

    end

    def buscar_siguiente(element, pos)
      if pos == 0
        element.text
      else
        buscar_siguiente(element.next_element, pos - 1)
      end
    end

    def buscar_anterior(element, pos)
      if pos == 0
        element.text
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
