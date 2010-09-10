# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
#
# Clase que realiza los reportes de una marca para busquedas
class BusquedaReport < ReporteMarcaReport

  def datos(reporte_marca)
    reporte_marca.reporte_marca_detalles.inject([]) do |arr, det|
      arr << [ det.busqueda, datos_marca(det.marca_propia), det.comentario ] unless det.comentario.blank?
      arr
    end
  end

  # Retorna un array con el encabezado de acuerdo a su idioma
  def encabezado
    if I18n.locale == :es
      ["Busquedas", "Marcas", "Comentarios"]
    else
      ["Search terms", "Trademarks", "Comments"]
    end
  end
end
