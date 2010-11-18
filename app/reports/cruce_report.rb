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
      row(0).style(:background_color => 'cccccc', :style => :bold)
      cells.style(:size => 8, :inline_format => true)
      column(0..5).style(:width => 80)
      column(0).style(:width => 120)
      column(5).style(:width => 250)
    end
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
      ["Signo vigilado", "Tipo", "Clase", "Numero", "Fecha", "Comentarios"]
    else
      ["Own trademarks","", "Foreign trademark", "Pub. Number", "Date", "Comments"]
    end
  end

  # Prepara los datos para la marca
  def datos_marca(marca)
    datos_array = []
    datos_array[0] = "#{ marca.nombre }"
    datos_array[1] = "#{ marca.tipo_signo }"
    datos_array[2] = "#{ marca.clase_id }"
    datos_array[3] = "#{ marca.numero_registro if marca.numero_registro }"
    datos_array[4] = "#{ I18n.l(marca.estado_fecha, :format => :date) if marca.estado_fecha}"
    datos_array[5] = "#{ marca.productos }"
    datos_array
  end
end