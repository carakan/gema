# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
module ModMarca::Solicitud
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
    base.set_validations_and_filters
  end

  module InstanceMethods
  end

  module ClassMethods

    # Define las validaciones y filtros que se deben aplicar a la clase
    def set_validations_and_filters
      # validaciones
      validates_presence_of :nombre, :fecha_solicitud, :tipo_signo_id, :clase_id
      validates_format_of :numero_solicitud, :with => /^\d+-\d{4}/
      validates_uniqueness_of :numero_solicitud#, :scope => :parent_id
    end

    def excel_cols
      {
        :fecha_solicitud => 'A',
        :numero_solicitud => 'B',
        :apoderado => 'C',
        :nombre => 'E',
        :tipo_signo_id => 'F',
        :titular_ids => 'D',
        :clase_id => 'G'
      }
    end

    # Realiza la importación de datos desde archivo Excel
    def importar_archivo(params)
      archivo = params[:archivo]
      fecha_solicitud = params[:fecha_solicitud]
      fecha_imp = DateTime.now.strftime("%Y-%m-%d %H:%I:%S")
      importar_excel(archivo)
      fila = 3 # Fila inicial que comienza el excel
      Importacion.transaction do
        @importacion = Importacion.create!(:archivo => archivo, :fecha_importacion => params[:fecha_imp], :tipo => params[:tipo] )

        for fila in ( 3..(@excel.last_row) )
          # valida de que no este vacio
          break if @excel.cell(fila, 1).blank? && @excel.cell(fila, 2).blank?
          klass = buscar_o_crear_marca(fila, fecha_imp)
        end

      end
      File.delete(@excel_path)

      @importacion.id
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
        klass.save(:validate => false )
      end

      klass
    end

    # Busca o crea una nueva solicitud
    def buscar_o_crear_marca(fila, fecha_imp)
      comp = [:apoderado, :tipo_signo_id, :clase_id, :nombre]
      klass = buscar_comparar_o_nuevo(get_excel_params(fila, fecha_imp), comp )
      # Salva correctamente o sino con errores
      unless klass.save
        klass.almacenar_errores
        klass.valido = false # Indica que no paso la validación
        klass.save(:validate => false )
      end

      klass
    end

    # Crea un representante y lo relaciona
    def buscar_o_crear_titular(params)
      rep = Representante.find_by_nombre(params[:titular_ids])
      if rep.blank?
        rep = Representante.new(
          :nombre => params[:titular_ids],
          :cliente => false
        )
        rep.save(:validate => false)
      end
      rep.id
    end

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
        :estado => 'sm',
        :importado => true,
        :importacion_id => @importacion.id
      }
      params.merge!(extraer_datos(fila, excel_cols) )
      params[:numero_solicitud] = preparar_numero_solicitud(params[:numero_solicitud])
      params[:tipo_signo_id] = buscar_tipo_signo_id(params[:tipo_signo_id])
      params[:clase_id] = buscar_clase_id(params[:clase_id])
      params[:titular_ids] = buscar_o_crear_titular(params)

      params
    end

  end
end
