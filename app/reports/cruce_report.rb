# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
#
# Clase que realiza los reportes de una marca para los cruces
class CruceReport < ReporteMarcaReport

  def datos(reporte_marca)
    reporte_marca.reporte_marca_detalles.inject([]) do |arr, det|
      arr << [ datos_marca(det.marca_propia), datos_marca(det.marca_foranea), det.comentario ] unless det.comentario.blank?
      arr
    end
  end

  # Retorna un array con el encabezado de acuerdo a su idioma
  def encabezado
    if I18n.locale == :es
      ["Marcas propia", "Marcas agenas", "Comentarios"]
    else
      ["Own trademarks", "Foreign trademark", "Comments"]
    end
  end
end
