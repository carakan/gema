# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
#
# Clase que realiza los reportes de una marca para los cruces
class ReporteMarcaReport < ReportBase
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
    table( [ encabezado ] + data, :header => true, :width => 550) do
      row(0).style(:background_color => 'cccccc', :style => :bold)
      cells.style(:size => 10, :inline_format => true)
      column(0).style(:width => 140)
      column(1).style(:width => 140)
    end
  end

  
  def tablaReporte
    tabla(@dataset)
  end

  # Metodos que deben ser sobreescritos
  # # REFACTOR!!!
  def datos(reporte_marca)
    reporte_marca.reporte_marca_detalles.inject([]) do |arr, det|
      arr << [ det.marca_propia.nombre, "#{det.marca_propia.tipo_marca.sigla if det.marca_propia.tipo_marca}", "#{det.marca_propia.clase_id}", det.comentario ] unless det.comentario.blank?
      arr
    end
  end
  # REFACTOR!!!
  # Retorna un array con el encabezado de acuerdo a su idioma
  def encabezado
    if I18n.locale == :es
      ["Signo vigilado", "Tipo", "Clase", "Comentarios"]
    else
      ["Own trademarks","", "Foreign trademark", "Comments"]
    end
  end


  # Prepara los datos para la marca
  def datos_marca(marca)
    if I18n.locale == :es
      <<-COM
      <b>#{ marca.nombre }</b>
      Clase #{ marca.clase_id }
      #{ marca.tipo_signo }
      <i>#{ marca.estado_fecha.nil? ? '' : I18n.l(marca.estado_fecha, :format => :date) }</i>
      #{ marca.titulares.join(", ") }
      COM
    else
      <<-COM
      <b>#{ marca.nombre }</b>
      Class #{marca.clase_id}
      #{ marca.tipo_signo.nil? ? '' : I18n.t(marca.tipo_signo.nombre.cambiar_acentos.downcase) }
      <i>#{ marca.estado_fecha.nil? ? '' : I18n.l( marca.estado_fecha, :format => :date) }</i>
      #{ marca.titulares.join(", ") }
      COM
    end
  end
end
