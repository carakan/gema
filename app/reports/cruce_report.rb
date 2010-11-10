# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
#
# Clase que realiza los reportes de una marca para los cruces
class CruceReport < ReporteMarcaReport
  # metodo que crea la tabla con las comparaciones
  def tabla(reporte_marca)
    data = datos(reporte_marca)
    table( [ encabezado ] + data, :header => true) do
      row(0).style(:background_color => 'cccccc', :style => :bold)
      cells.style(:size => 8, :inline_format => true)
      column(0..5).style(:width => 80)
    end
  end
end
