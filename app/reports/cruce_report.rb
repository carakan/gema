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
    table( [ encabezado ] + datos(reporte_marca), :header => true, :width => 550) do
      row(0).style(:background_color => 'cccccc', :style => :bold)
      cells.style(:size => 11)
      column(0).style(:width => 125)
      column(1).style(:width => 125)
      column(2).style(:width => 300)
    end
  end

  def datos(reporte_marca)
    reporte_marca.reporte_marca_detalles.inject([]) do |arr, det|
      arr << [ datos_marca(det.marca_propia), datos_marca(det.marca_foranea), det.comentario ] unless det.comentario.blank?
    end
  end

  def datos_marca(marca)
    if I18n.locale == :es
      "#{ marca.nombre }\n\n Clase #{marca.clase_id}\n#{marca.tipo_signo}\n#{ I18n.l marca.estado_fecha, :format => :date }"
    else
      "#{ marca.nombre }\n\n Class #{marca.clase_id}\n
      #{ I18n.t marca.tipo_signo.nombre.cambiar_acentos.downcase }\n#{ I18n.l marca.estado_fecha, :format => :date }"
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
