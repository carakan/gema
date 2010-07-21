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
      fecha_imp = DateTime.now.strftime("%Y-%m-%d %H:%I:%S")
      
      extension, cont_type = [ File.extname( archivo.original_filename ).downcase, archivo.content_type ]

      if extension == '.xls' and cont_type == 'application/vnd.ms-excel'
        importar_archivo_excel(archivo)
      elsif extension == '.pdf' and cont_type == 'application/pdf'
        include ModMarca::PDF
        importar_pdf(archivo, obtener_path_parametros_pdf)
      else
        raise "Existio un error debe seleccionar un archivo PDF o Excel"
      end
    end

    
    ############################################################
    # Metodos para realizar la importacion desde un PDF
    ############################################################ 


    # Crea una instancia de la clase Marca cuando se importa un PDF
    def crear_marca_pdf(params, hoja)
      klass = new( get_pdf_params(params, hoja) )
      # Salva correctamente o sino con errores
      unless klass.save
        klass.activo = false
        klass.valido = false # Indica que no paso la validación
        klass.save( false )
      end

      klass
    end

    # Utiliza los parametros que se importaron desde marca par poder
    # darles el formato para salvar
    #   @param Hash
    #   @param hoja
    #   @return Marca
    def get_pdf_params(params, hoja)
      { 
        :activo => true,
        :valido => true, 
        :fila => hoja, 
        :propia => false,
        :fecha_importacion => fecha_imp,
        :estado => 'lp',
        :importado => true,
        :numero_gaceta => nro_gaceta,
        :numero_publicacion => params['NUMERO DE PUBLICACION'],
        :nombre => params['NOMBRE DE LA MARCA']
      }
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
        klass.activo = false
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

