# encoding: utf-8
class SolicitudMarca < Marca
  

  # Columnas en archivo excel
  EXCEL_COLS = {
    :estado_fecha => 'A', # No es necesario dado que se ingresa la fecha
    :numero_solicitud => 'B',
    :nombre => 'E'
    # :tipo_signo_id => 'F',
    #:clase_id => 'G'
  }

  # Realiza la importación desde un archivo excel
  # @param RackFile
  # @return array
  def self.importar(archivo)
    # validar
    importacion_validar_archivo(archivo)
    # seleccionar excel
    crear_excel(archivo)

    fecha_imp = DateTime.now.strftime("%Y-%m-%d %H:%I:%S")

    self.transaction do |trans|
      for i in ( 3..(@excel.last_row) )
        # valida de que no este vacio
        break if @excel.cell(i, 1).blank? && @excel.cell(i, 2).blank?

        # Validacion en caso de que haya fallado en medio de la importacion
        # Si se encuentra el numero_solicitud realizar acciones sino continuar
        klass = crear_nueva_solicitud(i, fecha_imp)
        #fecha_imp = klass.fecha_importacion
      end
    end
    File.delete(@excel_path)
    
    fecha_imp#.strftime("%Y-%m-%d %H:%I:%S")
    
  end

  # Verifica de que el archivo sea valido
  def self.importacion_validar_archivo(archivo)
    raise "Debe seleccionar un archivo" if archivo.nil?
    raise "Solo se permite archivos excel" unless File.extname(archivo.original_filename.downcase) == ".xls"
  end

  
  # Prepara el archivo excel
  def self.crear_excel(archivo)
    @excel_path = File.join( Rails.root, 'archivos/temp/', File.basename( archivo.path ) + '.xls' )
    FileUtils.mv( archivo.path, @excel_path )
    @excel = Excel.new(@excel_path)
  end


  # Crea nueva solicitud
  def self.crear_nueva_solicitud(fila, fecha_imp)

    klass = set_klass(fila, fecha_imp)

    unless klass.save
      # Salva todas las clases con error
      klass.activo = false
      klass.valido = false
      klass.save( false )
    end

    klass
  end

  # Crea una instancia de SolicitudMarca con los datos de excel
  def self.set_klass(fila, fecha_imp)
    # Buscar agente y titular
    agente = Agente.find_or_create_by_nombre(:nombre => @excel.cell(fila, 'C').to_s.strip, :validar => false )
    titular = Titular.find_or_create_by_nombre(:nombre => @excel.cell(fila, 'D').to_s.strip, :validar => false )

    klass = new( :activo => true, :valido => true, :fila => fila, :propia => false,
                     :fecha_importacion => fecha_imp, :estado => 'sm',
                   :agente_id => agente.id, :titular_id => titular.id )

    EXCEL_COLS.each{ |k, v| klass.send("#{k}=", @excel.cell(fila, v) ) }
    c = Clase.find_by_codigo(@excel.cell(fila, 'G'))
    klass.clase_id = c.id unless c.nil?
    
    preparar_numero_solicitud(klass)
    set_tipo_signo(klass, fila)

    klass
  end

  # @oaram SolicitudMarca
  def self.preparar_numero_solicitud(klass)
    klass.numero_solicitud = klass.numero_solicitud.gsub(/\s/, '').gsub(/–/, '-') unless klass.numero_solicitud.nil?
  end

  # @param SolicitudMarca
  # @param Integer fila
  def self.set_tipo_signo(klass, fila)
    t = TipoSigno.find_by_nombre_or_sigla(@excel.cell(fila, 'F'), @excel.cell(fila, 'F') )
    klass.tipo_signo_id = t.id unless t.nil?
  end

end
