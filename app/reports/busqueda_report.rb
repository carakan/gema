# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
#
# Clase que realiza los reportes de una marca para busquedas
class BusquedaReport < ReporteMarcaBase
  attr_accessor :busqueda, :clases

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
      ["Nro.", "Signo", "Tipo", "Cl.", "Número", "Fecha", "Titular", "Observaciones"].collect{ |word| word.upcase}
    else
      ["Nr.", "Sign", "Type", "Class", "Number", "Date", "Owner/Applicant",  "Observations"].collect{ |word| word.upcase}
    end
  end

  def analisis
    text("<b>Análisis</b>", :inline_format => true)
    text(@observacion.to_s, :inline_format => true)
  end

  def palabra_busqueda
    "<b>#{@busqueda.upcase if @busqueda}</b>"
  end

  def clase_en_busqueda
    if @clases.length < 45
      "<b>#{@clases.join(", ")}</b>"
    else
      "<b>Todas</b>"
    end
  end

  def tabla(reporte_marca)
    data = datos(reporte_marca)
    table( [ encabezado ] + data, :header => true, :width => 700) do
      row(0).style(:background_color => 'cccccc', :style => :bold, :align => :center)
      cells.style(:size => 8, :inline_format => true)
      column(0).style(:width => 35)
      column(6).style(:width => 200)
      column(7).style(:width => 300)
      column(1..5).style(:width => 100)
      column(2..3).style(:width => 60)
    end
  end
end
