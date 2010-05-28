# encoding: utf-8
class SolicitudMarca < Marca
 
  attr_accessor :fila

  # Realiza la importación desde un archivo excel
  # @param RackFile
  # @return array
  def self.importar(archivo)
    excel_path = File.join(Rails.root, 'archivos/temp/', File.basename( archivo.path ) + '.xls' )
    FileUtils.mv( archivo.path, excel_path )
    @errors = []
    excel = Excel.new(excel_path)
    tot = 0

    for i in ( 3..(excel.last_row) )
      # valida de que no este vacio
      break if excel.cell(i, 1).blank? && excel.cell(i, 2).blank?
      klass = self.new( :activo => true )
      EXCEL_COLS.each{ |k, v| klass.send("#{k}=", excel.cell(i, v) ) }
      klass.estado = "sm"
      unless klass.save
        # Salva todas las clases con error
        klass.activo = false
        klass.fila = i
        klass.save( false )
        @errors.push( klass )
      else
        tot += 1
      end
    end
    File.delete(excel_path)

    [@errors, tot]
  end

end
