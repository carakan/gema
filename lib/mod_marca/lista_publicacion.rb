# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
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
      validates_length_of :numero_publicacion, :in => 6..12, :allow_nil => true, :allow_blank => true
      validates_presence_of :fecha_solicitud, :numero_gaceta
      validates_format_of :numero_solicitud, :with => /^\d+-\d{4}/
      validates_uniqueness_of :numero_solicitud#, :scope => :parent_id
      #validates_presence_of :numero_publicacion, :numero_gaceta
    end

    def excel_cols
      {
        :fecha_solicitud => 'A',
        :numero_solicitud => 'B',
        :apoderado => 'C',
        :nombre => 'E',
        :tipo_signo_id => 'F',
        :clase_id => 'G',
        :numero_publicacion => 'H',
        :numero_gaceta => 'J'
      }
    end

    # Retorna el lugar donde se encuentra el archivo parametrizable del pdf
    def obtener_path_parametros_pdf
      File.join(Rails.root, 'lib/mod_marca/lista_publicacion_pdf.yml')
    end

    # Realiza la importación de datos desde archivo Excel o PDF
    def importar_archivo(params)
      archivo, @nro_gaceta = [ params[:archivo], params[:publicacion] ]
      @fecha_imp = DateTime.now.strftime("%Y-%m-%d %H:%I:%S")
      @formato_fecha = params.delete(:formato_fecha)
      @fecha_publicacion = params[:publicacion_fecha]

      Importacion.transaction do
        @importacion = Importacion.create!(params)
        extension, cont_type = [ File.extname( archivo.original_filename ).downcase, archivo.content_type ]
        if extension == '.xls'# and cont_type == 'application/vnd.ms-excel'
          importar_archivo_excel(archivo)
        elsif extension == '.pdf'# and cont_type == 'application/pdf'
          include ModMarca::PDF
          importar_pdf(archivo, obtener_path_parametros_pdf)
        else
          raise "Existio un error debe seleccionar un archivo PDF o Excel"
        end
      end
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
      comp = [ :apoderado, :tipo_signo_id, :clase_id, :nombre, :tipo_marca_id, :titular_ids, :productos, :numero_gaceta, :numero_publicacion, :fecha_publicacion, :productos, :apoderado, :domicilio_titular, :estado]
      params[:fecha_publicacion] = @fecha_publicacion
      klass = buscar_comparar_o_nuevo(params, comp)
      klass.actualizar_clientes_propios if klass.propia
      unless klass.save
        klass.valido = false # Indica que no paso la validación
        klass.almacenar_errores
        klass.save(:validate => false )
      end
      klass
    end

    # Metodo que sirve para poder adjuntar imagenes
    #   @param Marca klass
    #   @param String img
    def adjuntar_imagen(klass, img)
      begin
        archivo = File.new(img)
        Adjunto.create( :archivo => archivo, :adjuntable_id => klass.id, :adjuntable_type => klass.class.to_s )
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
        :fecha_solicitud => convertir_fecha_solicitud( params['FECHA DE SOLICITUD'] ), # Esta es la Fecha de solicitud
        :clase_id => Clase.find_by_codigo(params['CLASE INTERNACIONAL']).try(:id),
        :tipo_signo_id => buscar_tipo_signo( params['TIPO DE SIGNO'], params['TIPO DE MARCA']),
        :tipo_marca_id => buscar_tipo_marca( params['TIPO DE SIGNO'], params['TIPO DE MARCA']),
        :titular_ids => [buscar_o_crear_titular(params)].compact,
        :apoderado => params['NOMBRE DEL APODERADO'],
        :productos => params['PRODUCTOS'],
        :importacion_id => @importacion.id,
        :domicilio_titular => params["DIRECCION DEL TITULAR"]
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

    def buscar_tipo_signo(signo,marca)
      tipo = validacion_signo_senapi_orpan(signo,marca)
      TipoSigno.find_by_nombre_or_sigla(tipo, tipo).try(:id)
    end

    def buscar_tipo_marca(signo, marca)
      tipo = validacion_marca_senapi_orpan(signo, marca)
      TipoMarca.find_by_nombre(tipo).try(:id)
    end

    # Crea un representante y lo relaciona
    def buscar_o_crear_titular(params)
      rep = Representante.where(["LOWER(nombre) = ?", params['NOMBRE DEL TITULAR'].downcase]).first
      pais = Pais.find_by_codigo(params['PAIS DEL TITULAR'])
      if rep
        if pais
          rep.pais_id = pais.id
          rep.pais_codigo = pais.codigo
          rep.pais_nombre = pais.nombre
        end
        rep.direccion = params['DIRECCION DEL TITULAR']
        rep.save(:validate => false)
      elsif !params['NOMBRE DEL TITULAR'].blank?
        rep = Representante.new(
          :nombre => params['NOMBRE DEL TITULAR'],
          :direccion => params['DIRECCION DEL TITULAR'],
          :cliente => false,
          :pais_id => pais.try(:id)
        )
        rep.save
      end
      rep.id
    end

    def validacion_signo_senapi_orpan(signo, marca)
      s = 'Otro'
      if signo == 'Denominación'
        s = 'Marca Denominativa'
        if (marca == 'Nombre Comercial')
          s = 'Nombre Comercial Denominativo'
        elsif (marca == 'Rótulo Comercial')
          s = 'Nombre Comercial Denominativo'
        elsif (marca == 'Lema Comercial')
          s = 'Lema Comercial'
        end

      elsif signo == 'Mixta'
        if marca =='Nombre Comercial'
          s = 'Nombre Comercial Mixto'
        else
          s = 'Marca Mixta'
        end

      elsif signo == 'Figurativa'
        s = 'Marca Figurativa'

      elsif (signo == 'Tridimensional')
        s = 'Marca Tridimensional'
      end

      s
    end

    def validacion_marca_senapi_orpan(signo,marca)
      m = 'Otro'
      if (marca == 'Marca Producto')
        m = 'Marca Producto'
      elsif (marca == 'Marca Servicio')
        m = 'Marca Servicio'
      elsif (marca == 'Marca Colectiva')
        m = 'Marca Colectiva'
      else (marca == 'Marca de Certificación')
        m = 'Marca de Certificación'
      end

      m
    end

    ############################################################
    # Metodos para realizar la importacion desde un Excel
    ############################################################ 

    # Realiza la importacion de datos de un archivo excel
    def importar_archivo_excel(archivo)
      fecha_imp = DateTime.now.strftime("%Y-%m-%d %H:%I:%S")
      importar_excel(archivo)
      fila = 3 # Fila inicial que comienza el excel
      @importacion = Importacion.create!(:archivo => archivo)

      transaction do |trans|
        for fila in ( 3..(@excel.last_row) )
          # valida de que no este vacio
          break if @excel.cell(fila, 1).blank? && @excel.cell(fila, 2).blank?
          #klass = crear_marca_excel(fila, fecha_imp)
          klass = buscar_o_crear_marca(fila, fecha_imp)
        end
      end

      File.delete(@excel_path)
      @importacion.id
      #fecha_imp
    end

    # Crea nueva solicitud
    #   @param Integer fila
    #   @param DateTime fecha_imp
    #   @return Marca
    def crear_nueva_solicitud(fila, fecha_imp)
      klass = Marca.new( get_excel_params(fila, fecha_imp) )

      # Salva correctamente o sino con errores
      unless klass.save
        klass.almacenar_errores
        klass.activo = false
        klass.valido = false # Indica que no paso la validación
        klass.save( :validate => false )
      end

      klass
    end

    # Busca o crea una nueva solicitud
    def buscar_o_crear_marca(fila, fecha_imp)
      comp = [:apoderado, :tipo_signo_id, :clase_id, :marca_estado_id, :nombre, :numero_solicitud]
      klass = buscar_comparar_o_nuevo(get_excel_params(fila, fecha_imp), comp )
      # Salva correctamente o sino con errores
      unless klass.save
        klass.almacenar_errores
        klass.valido = false # Indica que no paso la validación
        klass.save( :validate => false )
      end

      klass
    end


    # Crea un registro de la clase Marca en la BD
    #   @param Integer fila
    #   @return Marca
    #def crear_marca_excel(fila, fecha_imp)
    #klass = Marca.new( get_excel_params(fila, fecha_imp) )

    ## Salva correctamente o sino con errores
    #unless klass.save
    #klass.valido = false # Indica que no paso la validación
    #klass.save( false )
    #end

    #klass
    #end

    # Obitiene los datos de la fila del excel
    # y retorna un array
    #   @param Integer fila
    #   @param DateTime fecha_imp
    #   @return Hash
    def get_excel_params(fila, fecha_imp)
      params = { 
        :activa => true,
        :valido => true, 
        :fila => fila, 
        :propia => false,
        :fecha_importacion => fecha_imp,
        :estado => 'lp',
        :numero_gaceta => nro_gaceta,
        :importado => true,
        :importacion_id => @importacion.id
      }
      params.merge!(extraer_datos(fila, excel_cols) )
      params[:numero_solicitud] = preparar_numero_solicitud(params[:numero_solicitud])
      params[:tipo_signo_id] = buscar_tipo_signo_id(params[:tipo_signo_id])
      params[:clase_id] = buscar_clase_id(params[:clase_id])

      params
    end

  end
end

