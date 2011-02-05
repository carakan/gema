# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
#
# Clase que realiza los reportes de una marca para los cruces
class CruceReport < ReporteMarcaBase
  attr_accessor :titulares, :importacion
  
  # metodo que crea la tabla con las comparaciones
  def tabla(reporte_marca)
    data = datos(reporte_marca)
    table( [ encabezado ] + data, :header => true) do
      row(0).style( :background_color => 'cccccc', :style => :bold, :align => :center, :valign => :center)
      cells.style(:size => 8, :inline_format => true)
      column(0..5).style(:width => 80)
      column(0).style(:width => 120)
      column(5).style(:width => 250)
      column(5).style(:width => 100)
    end
  end

  def fecha_vencimiento
    "#{I18n.l(@importacion.fecha_limite.to_date, :format => :long) if @importacion.fecha_limite}"
  end

  def fecha_vencimiento_orpan
    "#{I18n.l(@importacion.fecha_limite_orpan.to_date, :format => :long) if @importacion.fecha_limite_orpan}"
  end

  def edicion_gaceta
    @importacion.publicacion
  end

  def numero_gaceta
    @importacion.publicacion
  end

  def fecha_gaceta
    "#{I18n.l(@importacion.publicacion_fecha.to_date, :format => :long) if @importacion.publicacion_fecha}"
  end

  def analisis
    if I18n.locale == :es
      text("<b>Análisis</b>", :inline_format => true)
      text(@observacion.to_s, :inline_format => true)
    else
      text("<b>Comments</b>", :inline_format => true)
      text(@observacion.to_s, :inline_format => true)
    end
  end

  def encabezado
    if I18n.locale == :es
      ["Signo vigilado", "Tipo", "Clase", "Número", "Fecha", "Titular" ,"Obsevaciones"]
    else
      ["Own trademarks", "Type", "Class", "Pub. Number", "Date", "Owner", "Observations"]
    end
  end

  # Prepara los datos para la marca
  def datos_marca(reporte_marca = nil)
    datos_array = []
    datos_array[0] = "#{ reporte_marca.marca_propia.nombre }"
    datos_array[1] = "#{ reporte_marca.marca_propia.tipo_signo.sigla if reporte_marca.marca_propia.tipo_signo }"
    datos_array[2] = "#{ reporte_marca.marca_propia.clase_id }"
    datos_array[3] = "#{ reporte_marca.marca_propia.numero_marca if reporte_marca.marca_propia.numero_marca }"
    datos_array[4] = "#{ I18n.l(reporte_marca.marca_propia.fecha_marca.to_date, :format => :short) if reporte_marca.marca_propia.fecha_marca}"
    datos_array[5] = "#{ reporte_marca.marca_propia.titulares.join(", ") }"
    datos_array[6] = "#{ reporte_marca.comentario }"
    datos_array
  end

  def datos(reporte_marca)
    reporte_marca.reporte_marca_detalles.inject([]) do |arr, reporte_marca|
      arr << datos_marca(reporte_marca)
      arr
    end
  end
end
