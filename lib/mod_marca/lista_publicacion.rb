module ModMarca::ListaPublicacion
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
    base.set_validations_and_filters
  end

  module InstanceMethods
  end

  module ClassMethods
    # Atributos comunes a traves de la importacion
    attr_accessor :nro_gaceta, :fecha_imp

    # Define las validaciones y filtros que se deben aplicar a la clase
    def set_validations_and_filters
      # validaciones
      validates_presence_of :nombre, :estado_fecha, 
        :tipo_signo_id, :clase_id
      validates_format_of :numero_solicitud, :with => /^\d+-\d{4}$/
      validates_uniqueness_of :numero_solicitud, :scope => :parent_id

      validates_presence_of :numero_publicacion, :numero_gaceta
    end

    def excel_cols
      {
        :estado_fecha => 'A',
        :numero_solicitud => 'B',
        :nombre => 'E',
        :tipo_signo_id => 'F',
        :clase_id => 'G'
      }
    end

    # Retorna el lugar donde se encuentra el archivo parametrizable del pdf
    def obtener_path_parametros_pdf
      File.join(Rails.root, 'lib/mod_marca/lista_publicacion_pdf.yml')
    end

    # Realiza la importación de datos desde archivo Excel o PDF
    def importar_archivo(params)
      archivo, @nro_gaceta = [ params[:archivo], params[:gaceta] ]
      @fecha_imp = DateTime.now.strftime("%Y-%m-%d %H:%I:%S")
      @importacion = Importacion.create!(:archivo => archivo, :publicacion => @nro_gaceta)
      @formato_fecha = params[:formato_fecha]

      extension, cont_type = [ File.extname( archivo.original_filename ).downcase, archivo.content_type ]

      if extension == '.xls'# and cont_type == 'application/vnd.ms-excel'
        importar_archivo_excel(archivo)
      elsif extension == '.pdf'# and cont_type == 'application/pdf'
        include ModMarca::PDF
        importar_pdf(archivo, obtener_path_parametros_pdf)
      else
        raise "Existio un error debe seleccionar un archivo PDF o Excel"
      end
      @importacion.update_attributes(:completa => true)

      @importacion.id
    end

    
    ############################################################
    # Metodos para realizar la importacion desde un PDF
    ############################################################ 


    # Crea una instancia de la clase Marca cuando se importa un PDF
    def crear_marca_pdf(params, hoja)
      img = params['imagen']
      klass = crear_o_actualizar( params, hoja )
      adjuntar_imagen(klass, img) unless img.nil?

      klass
    end

    # Busca la marca que debe actualizar o crear una nueva
    def crear_o_actualizar(params, hoja)
      params = get_pdf_params( params, hoja)
      comp = [ :apoderado, :tipo_signo_id, :clase_id, :nombre, :tipo_marca_id, :titular_ids, :productos ]
      klass = buscar_comparar_o_nuevo(params, comp)

      # Salva correctamente o sino con errores
      unless klass.save
        klass.valido = false # Indica que no paso la validación
        klass.almacenar_errores
        klass.save( false )
      end

      klass
    end

    # Metodo que sirve para poder adjuntar imagenes
    #   @param Marca klass
    #   @param String img
    def adjuntar_imagen(klass, img)
      begin
        archivo = File.new(img)
        Adjunto.create:archivo => archivo, :adjuntable_id => klass.id, :adjuntable_type => klass.class.to_s )
      rescue
      end
    end

    # Utiliza los parametros que se importaron desde marca par poder
    # darles el formato para salvar
    #   @param Hash
    #   @param hoja
    #   @return Marca
    def get_pdf_params(params, hoja)
      { 
        :activa => true,
        :valido => true, 
        :fila => hoja, 
        :propia => false,
        :fecha_importacion => @fecha_imp,
        :estado => 'lp',
        :importado => true,
        :numero_gaceta => nro_gaceta,
        :numero_publicacion => params['NUMERO DE PUBLICACION'],
        :nombre => params['NOMBRE DE LA MARCA'],
        :numero_solicitud => params['NUMERO DE SOLICITUD'].gsub(/(\s|\302\240)/, ''),
        :estado_fecha => convertir_fecha_solicitud( params['FECHA DE SOLICITUD'] ), # Esta es la Fecha de solicitud
        :clase_id => Clase.find_by_codigo(params['CLASE INTERNACIONAL']).try(:id),
        :tipo_signo_id => buscar_tipo_signo( params['TIPO DE SIGNO'] ),
        :tipo_marca_id => buscar_tipo_marca( params['TIPO DE MARCA'] ),
        :titular_ids => [buscar_o_crear_titular(params)].compact,
        :apoderado => params['NOMBRE DEL APODERADO'],
        :productos => params['PRODUCTOS'],
        :importacion_id => @importacion.id
      }

    end

    def convertir_fecha_solicitud(fec)
      @orden_reg_fecha ||= orden_reg_fecha

      if fec =~ /(-|\/)/
        fec.gsub(/([0-9]+)[-\/]([0-9]+)[-\/]([0-9]+)/, @orden_reg_fecha)
      elsif fec.is_a?(String) and fec.size == 8
        fec.gsub(@reg_fecha_sin_sep, @orden_reg_fecha)
      end
    end


    # Se define expresiones regulares para poder calcular la fecha
    def orden_reg_fecha
      case @formato_fecha
      when 'd-m-y'
        @reg_fecha_sin_sep = /([0-9]{2})([0-9]{2})([0-9]{4})/
        '\3-\2-\1'
      when 'm-d-y'
        @reg_fecha_sin_sep = /([0-9]{2})([0-9]{2})([0-9]{4})/
        '\3-\1-\2'
      when 'y-m-d'
        @reg_fecha_sin_sep = /([0-9]{4})([0-9]{2})([0-9]{2})/
        '\1-\2-\3'
      end
    end

    def buscar_tipo_signo( sig )
      TipoSigno.find_by_nombre_or_sigla(sig, sig).try(:id)
    end

    def buscar_tipo_marca(tip)
      TipoMarca.find_by_nombre(tip).try(:id)
    end

    def buscar_o_crear_titular(params)
      tit = Titular.find_by_nombre(params['NOMBRE DEL TITULAR'])
      if tit
        tit.update_attributes(:direccion => params['DIRECCION DEL TITULAR'])
      elsif not params['NOMBRE DEL TITULAR'].blank?
        tit = Titular.new(
          :nombre => params['NOMBRE DEL TITULAR'],
          :direccion => params['DIRECCION DEL TITULAR'],
          :pais_id => Pais.find_by_codigo(params['PAIS DEL TITULAR']).try(:id)
        )
        tit.save
      end
      tit.id
    end



    ############################################################
    # Metodos para realizar la importacion desde un Excel
    ############################################################ 

    # Realiza la importacion de datos de un archivo excel
    def importar_archivo_excel(archivo)
      importar_excel(archivo)
      fila = 3 # Fila inicial que comienza el excel

      transaction do |trans|
        for fila in ( 3..(@excel.last_row) )
          # valida de que no este vacio
          break if @excel.cell(fila, 1).blank? && @excel.cell(fila, 2).blank?
          klass = crear_marca_excel(fila)
        end
      end

      File.delete(@excel_path)

      fecha_imp
    end


    # Crea un registro de la clase Marca en la BD
    #   @param Integer fila
    #   @return Marca
    def crear_marca_excel(fila)
      klass = Marca.new( get_excel_params(fila) )

      # Salva correctamente o sino con errores
      unless klass.save
        klass.valido = false # Indica que no paso la validación
        klass.save( false )
      end

      klass
    end

    # Obitiene los datos de la fila del excel
    # y retorna un array
    #   @param Integer fila
    #   @param DateTime fecha_imp
    #   @return Hash
    def get_excel_params(fila, fecha_imp)
      params = { 
        :activo => true,
        :valido => true, 
        :fila => fila, 
        :propia => false,
        :fecha_importacion => fecha_imp,
        :estado => 'lp',
        :importado => true,
        :numero_gaceta => nro_gaceta
      }
      params.merge!(extraer_datos(fila, excel_cols) )
      params[:numero_solicitud] = preparar_numero_solicitud(params[:numero_solicitud])
      params[:tipo_signo_id] = buscar_tipo_signo_id(params[:tipo_signo_id])
      params[:clase_id] = buscar_clase_id(params[:clase_id])

      params
    end

  end
end

