module ModMarca
  module Excel
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.send(:extend, ClassMethods)
    end
    
    module InstanceMethods
    end

    module ClassMethods
      def importar_excel(archivo, tmp_dir = 'archivos/temp/')
        crear_excel(archivo, tmp_dir)
      end

      # Prepara el archivo excel para las importaciones
      def self.crear_excel(archivo, tmp_dir)
        verificar_validez_archivo(archivo)

        @excel_path = File.join( Rails.root, tmp_dir, File.basename( archivo.path ) + '.xls' )
        FileUtils.mv( archivo.path, @excel_path )
        @excel = Excel.new(@excel_path)
      end

      # Verifica de que el archivo sea valido
      def self.verificar_validez_archivo(archivo)
        raise "Debe seleccionar un archivo" if archivo.nil?
        raise "Solo se permite archivos excel" unless File.extname(archivo.original_filename.downcase) == ".xls"
      end

      # Extrae los datos de un archivo excel Roo
      # con la fila y un conf = Hash ({:clase_id => 'C', :nombre => 'D'})
      def self.extraer_datos(fila, conf)
        conf.inject({}) { |h, v| h[v.first] = @excel.cell(fila, v.last); v }
      end

    end

  end

end
