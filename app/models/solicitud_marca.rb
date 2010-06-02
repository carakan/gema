# encoding: utf-8
class SolicitudMarca < Marca
 
  attr_accessor :fila

  # Realiza la importación desde un archivo excel
  # @param RackFile
  # @return array
  def self.importar(archivo, fecha)
    return @errors = [ "Debe seleccionar un archivo", false ] if archivo.nil?
    

    excel_path = File.join(Rails.root, 'archivos/temp/', File.basename( archivo.path ) + '.xls' )
    FileUtils.mv( archivo.path, excel_path )
    @errors = []
    excel = Excel.new(excel_path)
    tot = 0
    fecha_imp = Time.now.to_i

    for i in ( 3..(excel.last_row) )
      # valida de que no este vacio
      break if excel.cell(i, 1).blank? && excel.cell(i, 2).blank?
      klass = self.new( :activo => true, :valido => true, :estado_fecha => fecha, :fecha_importacion => fecha_imp )
      EXCEL_COLS.each{ |k, v| klass.send("#{k}=", excel.cell(i, v) ) }
      klass.sm.gsub!(/\s/, '').gsub!(/–/, '-') # Para que se pueda tener un formato definido
      # Validacion en caso de que haya fallado en medio de la importacion
      # Si se encuentra el sm realizar acciones sino continuar
      unless self.find_by_sm( klass.sm )

        klass.estado = "sm"
        unless klass.save
          # Salva todas las clases con error
          klass.activo = false
          klass.valido = false
          klass.fila = i
          klass.save( false )
          @errors.push( klass )
        else
          tot += 1
        end
      end
    end
    File.delete(excel_path)

    [@errors, tot]
  end

end
