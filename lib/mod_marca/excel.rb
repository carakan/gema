# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
module ModMarca::Excel
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

      @excel_path = File.join( Rails.root, tmp_dir, File.basename( archivo.tempfile.path ) + '.xls' )
      FileUtils.mv( archivo.tempfile.path, @excel_path )
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

    def validacion_signo_senapi_orpan(signo,marca)
      s = 'Otro'
      if (signo == 'Denominación')
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
        elsif 
          s = 'Marca Mixta'
        end

      elsif (signo == 'Figurativa')
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

  end

end
