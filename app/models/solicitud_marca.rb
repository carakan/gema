# encoding: utf-8
class SolicitudMarca < Marca
 

  # Realiza la importación desde un archivo excel
  # @param RackFile
  # @return array
  def self.importar(archivo)
    excel_path = File.join(Rails.root, 'archivos/temp/', File.basename( archivo.path ) + '.xls' )
    FileUtils.mv( archivo.path, excel_path )
    errors = []
    debugger
    excel = Excel.new(excel_path)

    for i in ( 2..(excel.last_row) )
      klass = self.new
      EXCEL_COLS.each{ |k, v| klass.send("#{k}=", excel.cell(i, v) ) }
      unless klass.save
        errors.push( { :fila => i, :errors => klass.errors } ) 
      end
    end
    File.delete(excel_path)

    errors
  end

end
