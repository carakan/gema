module Solicitud
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
  end

  module InstanceMethods
    # Columnas en archivo excel
    @excel_cols = {
      :estado_fecha => 'A', # No es necesario dado que se ingresa la fecha
      :numero_solicitud => 'B',
      :nombre => 'E'
      # :tipo_signo_id => 'F',
      #:clase_id => 'G'
    }
  end

  module ClassMethods
    # Realiza la importación de datos desde archivo Excel
    def self.importar_archivo(archivo)
      fecha_imp = DateTime.now.strftime("%Y-%m-%d %H:%I:%S")

    end
  end
end
