module ModMarca::Solicitud
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
  end

  module InstanceMethods
  end

  module ClassMethods
    def excel_cols
      {
        :estado_fecha => 'A',
        :numero_solicitud => 'B',
        :nombre => 'E',
        :tipo_signo_id => 'F',
        :clase_id => 'G'
      }
    end

    # Realiza la importación de datos desde archivo Excel
    def importar_archivo(archivo)
      fecha_imp = DateTime.now.strftime("%Y-%m-%d %H:%I:%S")
      importar_excel(archivo)
      fila = 3 # Fila inicial que comienza el excel

      Marca.transaction do |trans|
        for fila in ( 3..(@excel.last_row) )
          # valida de que no este vacio
          break if @excel.cell(fila, 1).blank? && @excel.cell(fila, 2).blank?
          klass = crear_nueva_solicitud(fila, fecha_imp)
        end
      end

      File.delete(@excel_path)

      fecha_imp
    end

    # Crea nueva solicitud
    #   @param Integer fila
    #   @param DateTime fecha_imp
    #   @return Marca
    def crear_nueva_solicitud(fila, fecha_imp)
      klass = Marca.new( get_excel_params(fila, fecha_imp) )

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
        :estado => 'sm'
      }
      params.merge!(extraer_datos(fila, excel_cols) )
      params[:numero_solicitud] = preparar_numero_solicitud(params[:numero_solicitud])
      params[:tipo_signo_id] = buscar_tipo_signo_id(params[:tipo_signo_id])
      params[:clase_id] = buscar_clase_id(params[:clase_id])

      params
    end

  end
end
