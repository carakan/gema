# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
#
# Clase que realiza los reportes de una marca para los cruces
class ReporteMarcaBase < ReportBase
  # metodo que crea el reporte
  def to_pdf(reporte_marca)
    I18n.locale = :en if reporte_marca.idioma == 'en'
    
    logo_orpan
    text "La Paz, #{I18n.l Date.today, :format => :long}\n\n"
    
    text reporte_marca.carta << "\n\n"
    tabla(reporte_marca)

    # Para que retorne a español en caso de que cambie
    I18n.locale = :es
    render
  end

  # metodo que crea la tabla con las comparaciones
  def tabla(reporte_marca)
    data = datos(reporte_marca)
    table( [ encabezado ] + data, :header => true, :width => 720) do
      row(0).style( :background_color => 'cccccc', :style => :bold, :align => :center, :valign => :center)
      cells.style(:size => 8, :inline_format => true)
      column(0..5).style(:width => 100)
    end
  end

  
  def tabla_reporte
    tabla(@dataset)
  end

  # Metodos que deben ser sobreescritos
  # # REFACTOR!!!
  def datos(reporte_marca)
    count = 1
    reporte_marca.reporte_marca_detalles.inject([]) do |arr, det|
      arr << [ datos_marca(det.marca_propia), det.comentario ].flatten
      arr
    end
  end
  # REFACTOR!!!
  # Retorna un array con el encabezado de acuerdo a su idioma
  def encabezado
    if I18n.locale == :es
      ["Signo vigilado", "Tipo", "Clase", "Numero", "Fecha", "Titulares", "Comentarios"]
    else
      ["Own trademarks","", "Foreign trademark", "Pub. Number", "Date", "Owner's", "Comments"]
    end
  end


  # Prepara los datos para la marca
  def datos_marca(marca)
    datos_array = []
    datos_array[0] = "#{ marca.nombre }"
    datos_array[1] = "#{ marca.tipo_signo.sigla if marca.tipo_signo }"
    datos_array[2] = "#{ marca.clase_id }"
    datos_array[3] = "#{ marca.numero_marca }"
    datos_array[4] = "#{ I18n.l(marca.fecha_marca, :format => :short) if marca.fecha_marca}"
    datos_array[5] = "#{ marca.titulares.join(", ") }"
    datos_array
  end
end
