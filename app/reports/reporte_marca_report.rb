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
    text "La Paz, #{I18n.l Date.today}\n\n"
    
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

  # Metodos que deben ser sobreescritos
  def datos; end
  def encabezado; end

  # Prepara los datos para la marca
  def datos_marca(marca)
    if I18n.locale == :es
      <<-COM
      <b>#{ marca.nombre }</b>
      Clase #{ marca.clase_id }
      #{ marca.tipo_signo }
      <i>#{ I18n.l marca.estado_fecha, :format => :date }</i>
      #{ marca.titulares.join(", ") }
      COM
    else
      <<-COM
      <b>#{ marca.nombre }</b>
      Class #{marca.clase_id}
      #{ I18n.t marca.tipo_signo.nombre.cambiar_acentos.downcase }
      <i>#{ I18n.l marca.estado_fecha, :format => :date }</i>
      #{ marca.titulares.join(", ") }
      COM
    end
  end

end
