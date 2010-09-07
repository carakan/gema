# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
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
      def crear_excel(archivo, tmp_dir)
        verificar_validez_archivo(archivo)

        @excel_path = File.join( Rails.root, tmp_dir, File.basename( archivo.path ) + '.xls' )
        FileUtils.mv( archivo.path, @excel_path )
        @excel = ::Excel.new(@excel_path)
      end

      # Verifica de que el archivo sea valido
      def verificar_validez_archivo(archivo)
        raise "Debe seleccionar un archivo" if archivo.nil?
        raise "Solo se permite archivos excel" unless File.extname(archivo.original_filename.downcase) == ".xls"
      end

      # Extrae los datos de un archivo excel Roo
      # con la fila y un conf = Hash ({:clase_id => 'C', :nombre => 'D'})
      def extraer_datos(fila, conf)
        conf.keys.inject({}) { |h, v| h[v] = @excel.cell(fila, conf[v]); h }
      end

    end

  end

end
