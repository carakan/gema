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
      column(5).style(:width => 300)
    end
  end

  def fecha_vencimiento
    "#{I18n.l(@importacion.fecha_limite, :format => :long) if @importacion.fecha_limite}"
  end

  def fecha_vencimiento_orpan
    "#{I18n.l(@importacion.fecha_limite_orpan, :format => :long) if @importacion.fecha_limite_orpan}"
  end

  def edicion_gaceta
    @importacion.publicacion
  end

  def numero_gaceta
    @importacion.publicacion
  end

  def fecha_gaceta
    "#{I18n.l(@importacion.publicacion_fecha, :format => :long)}"
  end

  def analisis
    text(@observacion.to_s, :inline_format => true)
  end

  def encabezado
    if I18n.locale == :es
      ["Signo vigilado", "Tipo", "Clase", "Número", "Fecha", "Comentarios"]
    else
      ["Own trademarks", "Type", "Class", "Pub. Number", "Date", "Comments"]
    end
  end

  # Prepara los datos para la marca
  def datos_marca(marca)
    datos_array = []
    datos_array[0] = "#{ marca.nombre }"
    datos_array[1] = "#{ marca.tipo_signo.sigla if marca.tipo_signo }"
    datos_array[2] = "#{ marca.clase_id }"
    datos_array[3] = "#{ marca.numero_registro if marca.numero_registro }"
    datos_array[4] = "#{ I18n.l(marca.estado_fecha, :format => :short) if marca.estado_fecha}"
    datos_array[5] = "#{ marca.productos }"
    datos_array
  end

  def datos(reporte_marca)
    reporte_marca.reporte_marca_detalles.inject([]) do |arr, det|
      arr << datos_marca(det.marca_propia)
      arr
    end
  end
end
