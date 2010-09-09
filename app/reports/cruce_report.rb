# encoding: utf-8
class CruceReport < Prawn::Document

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

  def logo_orpan
    create_stamp("logo_orpan") do
      image "#{Rails.root}/public/images/logo-orpan.jpg", :vposition => -30, :fit => [100, 70]
    end
    stamp("logo_orpan")
  end

  def tabla(reporte_marca)
    data = datos(reporte_marca)
    table( [ encabezado ] + data, :header => true, :width => 550) do
      row(0).style(:background_color => 'cccccc', :style => :bold)
      cells.style(:size => 10, :inline_format => true)
      column(0).style(:width => 125)
      column(1).style(:width => 125)
      column(2).style(:width => 300)
    end
  end

  def datos(reporte_marca)
    reporte_marca.reporte_marca_detalles.inject([]) do |arr, det|
      arr << [ datos_marca(det.marca_propia), datos_marca(det.marca_foranea), det.comentario ] unless det.comentario.blank?
      arr
    end
  end

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

  def encabezado
    if I18n.locale == :es
      ["Marca propia", "Marca agena", "Comentario"]
    else
      ["Own trademark", "Foreign trademark", "Comments"]
    end
  end
end
