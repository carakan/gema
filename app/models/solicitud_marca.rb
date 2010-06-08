# encoding: utf-8
class SolicitudMarca < Marca
 
  attr_accessor :fila

  # Realiza la importación desde un archivo excel
  # @param RackFile
  # @return array
  def self.importar(archivo)
    return @errors = [ "Debe seleccionar un archivo", false ] if archivo.nil?
    

    excel_path = File.join(Rails.root, 'archivos/temp/', File.basename( archivo.path ) + '.xls' )
    FileUtils.mv( archivo.path, excel_path )
    excel = Excel.new(excel_path)
    fecha_imp = DateTime.now.utc

    for i in ( 3..(excel.last_row) )
      # valida de que no este vacio
      break if excel.cell(i, 1).blank? && excel.cell(i, 2).blank?
      klass = self.new( :activo => true, :valido => true, :fecha_importacion => fecha_imp )
      EXCEL_COLS.each{ |k, v| klass.send("#{k}=", excel.cell(i, v) ) }
      # Para que se pueda tener un formato definido
      klass.numero_solicitud = klass.numero_solicitud.gsub(/\s/, '').gsub(/–/, '-') unless klass.numero_solicitud.nil? 
      # Validacion en caso de que haya fallado en medio de la importacion
      # Si se encuentra el numero_solicitud realizar acciones sino continuar
      self.transaction do |trans|
        unless self.find_by_numero_solicitud( klass.numero_solicitud )

          klass.estado = "sm"
          unless klass.save
            # Salva todas las clases con error
            klass.activo = false
            klass.valido = false
            klass.fila = i
            klass.save( false )
          else
            tot += 1
          end
        end
      end
    end
    File.delete(excel_path)
    
    fecha_imp
    
  end

end
