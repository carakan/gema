# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
#
# Este modulo utiliza el programa pdftohtml http://pdftohtml.sourceforge.net/
# Cuando se utiliza este programa para convertir el PDF en html este covierte el PDF
# en varios archivos *.html y *.png, cada html tiene solo una imagen .png que despues
# es necesaria recortarla para poder extraer la imagen deseada del logo. Para poder extraer
# los datos utila un archivo .yml "yaml" que indica la sección y el orden en el cual debe
# realizar las busquedas para que encuentre los datos
module ModMarca::PDF

  def self.included(base)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods
    attr_accessor :pdf_dir, :pdf_archivo, :pdf_parametros, :pdf_path,
      :css_selector, :lista_seleccionada, :seccion, :posicion

    REGEXP = /[^\w\sÑñáéíóú]/i
    REGMARCA = /[^\w\sÑñáéíóú()]/i
    REGBLANK = /\302\240/

    # metodo que se encarga de la importacion del archivo y utiliza el metodo
    # "crear_instancia_pdf" que se encuentra en lib/mod_marca/lista_publicacion.rb
    #   @param TmpFile archivo
    #   @param String yaml
    def importar_pdf(*args)
      preparar_importacion_pdf(args)
      @seccion = 'DENOMINATIVAS'
      @lista_seleccionada = pdf_parametros[@seccion]
      rango = crear_rango()

      rango.each do |num|
        arr = extraer_datos_html(crear_nombre_archivo_html(num), num )
        # Metodo utilizado para actualizar en la clase
        arr.each do |params|
          # crear_instancia_pdf  se encuentra en el archivo lista_publicacion
          # lib/mod_marca/lista_publicacion.rb
          m = crear_marca_pdf(params, num)
        end
      end

      borrar_directorio_pdf(@pdf_archivo)
    end

    # Crea el rango para poder iterar en orden por la lista de hojas html
    def crear_rango()
      (1..Dir.glob("#{pdf_dir}/*.png").size)
    end

    def crear_nombre_archivo_html(num)
      @nombre_basico ||= pdf_archivo.gsub(File.extname(pdf_archivo), '')
      %Q(#{@nombre_basico}-#{num}.html) 
    end

    # Realiza la busqueda de seccion dependiendo de la hoja
    #   @param Array #  divs lista de objetos Nokogiri
    def buscar_seccion(divs)
      divs.each do |div|
        case div.text.gsub(REGBLANK, '').strip
          when 'DENOMINATIVAS'
            self.seccion = @seccion = 'DENOMINATIVAS'
          when 'FIGURATIVAS'
            self.seccion = @seccion = 'FIGURATIVAS'
        end
      end
      @lista_seleccionada = pdf_parametros[@seccion]
    end

    # Prepara los datos para realizar la importación de un PDF
    # options es un Hash de opciones
    #   @params args Array # => [archivo, archivo_parametros_pdf, options]
    def preparar_importacion_pdf(args)
      options = args.extract_options! || {}

      self.css_selector = options[:css_selector] || 'div>div'
      pdf_path = options[:pdf_path] || File.join(Rails.root, 'archivos/temp/pdf')

      self.pdf_archivo = preparar_pdf(pdf_path, args[0])
      convertir_pdf(pdf_archivo)

      self.pdf_parametros = YAML.load_file(args[1])
      self.pdf_dir = File.dirname(pdf_archivo)
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
    #   @param Integer num
    #   @return Array # Retorna un array con varios Hash, en una hoja hay varias marcas
    def extraer_datos_html(html, num)
      n = Nokogiri::HTML( File.open(html) )
      @posicion = 0
      arr = []
      divs = n.css(css_selector)
      @fin = false

      divs.each_with_index do |div, ind| 

        hash = {}
        @lista_seleccionada.each do |key, desp|
          primero = @lista_seleccionada.first[0] == key
          hash[key] = buscar_por_nombre(divs, key, desp, primero)
          # Extraccion de images
          if hash[key].class == String and primero and @seccion == 'FIGURATIVAS' and hash['imagen'].nil?
            hash['imagen'] = extraer_imagen(divs[@posicion - desp], num)
          end

          if hash[key] == false
            hash.delete(key)
            buscar_seccion(divs)
            break
          end
        end

        arr << hash

        break if @posicion == (divs.size - 1)
      end
      arr.delete_if{ |h| h.blank? }

      arr
    end

    # Extraccion de imagen
    # Para la extraccion de la imagen es necesario saber la posicion 
    # Realiza el crop de imagenes para extraer el logo
    #   @param Nokogiri::XML::Element
    #   @param num
    def extraer_imagen(div, num)
      x = 417
      y = div[:style].gsub(/.*(top:[0-9]+).*/, '\1').gsub(/top:/, '').to_i + 6
      img = buscar_imagen(num)
      to_img = "#{@nombre_basico}-#{Time.now.to_f}.png"
      raise "Error debe instalar ImageMagick" unless system("convert #{img} -crop 130x130+417+#{y} #{to_img}")
      to_img
    end

    # Busca la imagen que corresponde al número de página que se ha extraido
    #   @param Integer
    #   @return String
    def buscar_imagen(num)
      (0..3).each do |v|
        img = [@nombre_basico, "0" * v, num, '.png'].join('')
        return img if File.exists? img
      end
    end

    # Busca dentro de los elemetos "div" de un listado .css Nokogiri por nombre
    #   @param element
    #   @param String nombre
    #   @param Integer pos
    #   @param [true, false] Ayuda a identificar si es el primero de la lista
    #   @return [String, false] # Retorna false en caso de que no encuentre o llegue al final
    def buscar_por_nombre(elements, nombre, desplazar, primero)
      # Identifica si es el primer elemento
      (@posicion..(elements.size - 1)).each do |i|
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

    # Se mueve hasta el siguiente elemento hasta que pos == 0
    #   @param Nokogiri::XML:Element
    #   @param Integer
    #   @return Nokogiri::XML::Element
    def buscar_siguiente(element, pos)
      if pos == 0
        element
      else
        buscar_siguiente(element.next_element, pos - 1)
      end
    end

    # Se mueve hasta el anterior elemento hasta que pos == 0
    #   @param Nokogiri::XML:Element
    #   @param Integer
    #   @return Nokogiri::XML::Element
    def buscar_anterior(element, pos)
      if pos == 0
        element
      else
        buscar_anterior(element.previous_element, pos + 1)
      end
    end

    # Prepara el archivo subido y lo copia en un directorio
    #   @param Rack:TempFile
    #   @param String
    #   @return String
    def preparar_pdf(pdf_path, archivo)
      raise "Error, el archivo selecionado no es un PDF" unless File.extname(archivo.original_filename).downcase == '.pdf'
      raise "Error, el directorio \"#{pdf_path}\" no existe al cual desea subir" unless File.exists?(pdf_path)

      dir = File.join( pdf_path, Time.now.to_i.to_s )
      FileUtils.mkdir(dir)
      path = "#{ dir }/#{ archivo.original_filename }"

      if Rails.version >= "3.0.3"
        FileUtils.mv( archivo.tempfile.path, path )
      else
        FileUtils.mv( archivo.path, path )
      end

      path
    end

    # Convierte un PDF en archivos de HTML usando pdftohtml "http://pdftohtml.sourceforge.net/"
    #   @param String # path al archivo PDF
    def convertir_pdf(pdf)
      raise "Error debe instalar pdftohtml" unless system("pdftohtml -c #{pdf}")
    end
  end

end
