# encoding: utf-8
class SolicitudMarca < Marca
 
  attr_accessor :fila

  # Realiza la importación desde un archivo excel
  # @param RackFile
  # @return array
  def self.importar(archivo)
    # validar
    importacion_validar_archivo(archivo)
    # seleccionar excel
    excel, excel_path = crear_excel(archivo)

    fecha_imp = DateTime.now.strftime("%Y-%m-%d %H:%I:%S")

    for i in ( 3..(excel.last_row) )
      # valida de que no este vacio
      break if excel.cell(i, 1).blank? && excel.cell(i, 2).blank?

      # Validacion en caso de que haya fallado en medio de la importacion
      # Si se encuentra el numero_solicitud realizar acciones sino continuar
      self.transaction do |trans|
        klass = crear_nueva_solicitud(excel, i, fecha_imp)
        fecha_imp = klass.fecha_importacion
      end

    end
    File.delete(excel_path)
    
    fecha_imp.strftime("%Y-%m-%d %H:%I:%S")
    
  end


  # Verifica de que el archivo sea valido
  def self.importacion_validar_archivo(archivo)
    raise "Debe seleccionar un archivo" if archivo.nil?
    raise "Solo se permite archivos excel" unless File.extname(archivo.original_filename.downcase) == ".xls"
  end

  
  # Prepara el archivo excel
  def self.crear_excel(archivo)
    excel_path = File.join( Rails.root, 'archivos/temp/', File.basename( archivo.path ) + '.xls' )
    FileUtils.mv( archivo.path, excel_path )
    [ Excel.new(excel_path), excel_path ]
  end


  # Crea nueva solicitud
  def self.crear_nueva_solicitud(excel, fila, fecha_imp)
    klass = self.new( :activo => true, :valido => true, 
                     :fecha_importacion => fecha_imp, :estado => 'sm' )

    EXCEL_COLS.each{ |k, v| klass.send("#{k}=", excel.cell(fila, v) ) }
    c = Clase.find_by_codigo(excel.cell(fila, 'G'))
    klass.clase_id = c.id unless c.nil?

    # Para que se pueda tener un formato definido
    klass.numero_solicitud = klass.numero_solicitud.gsub(/\s/, '').gsub(/–/, '-') unless klass.numero_solicitud.nil? 
    # Buscar id de la denominacion
    t = TipoMarca.find_by_nombre_or_sigla(excel.cell(fila, 'F'), excel.cell(fila, 'F') )
    klass.tipo_marca_id = t.id

    unless klass.save
      # Salva todas las clases con error
      klass.activo = false
      klass.valido = false
      klass.fila = fila
      klass.save( false )
    end

    klass
  end

  # Chapi test
  #def self.er
  #  raise "Error"
  #end

end
