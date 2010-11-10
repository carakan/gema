# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
#
# Clase que realiza los reportes de una marca para busquedas
class BusquedaReport < ReporteMarcaReport
  def datos(reporte_marca)
    count = 1
    reporte_marca.reporte_marca_detalles.inject([]) do |arr, det|
      arr << [ count.to_s, datos_marca(det.marca_propia), det.comentario ].flatten
      count += 1
      arr
    end
  end

  # Retorna un array con el encabezado de acuerdo a su idioma
  def encabezado
    if I18n.locale == :es
      ["Nro.", "Signo", "Tipo", "Clase", "Numero", "Fecha", "Titular", "Observaciones"]
    else
      ["Nr.", "Sign", "Type", "Class", "Number", "Date", "Owner/Applicant",  "Observations"]
    end
  end

  def analisis
    text("<b>Analisis</b>", :inline_format => true)
    text(@observacion.to_s, :inline_format => true)
  end

  def palabra_busqueda
    "#{@dataset.reporte_marca_detalles.first.busqueda if @dataset}"
  end

  def clase_en_busqueda
    "Aca van las clases"
  end

  def tabla(reporte_marca)
    data = datos(reporte_marca)
    table( [ encabezado ] + data, :header => true, :width => 720) do
      row(0).style(:background_color => 'cccccc', :style => :bold)
      cells.style(:size => 8, :inline_format => true)
      column(0).style(:width => 35)
      column(1..5).style(:width => 100)
    end
  end
end
