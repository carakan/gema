module ReporteMarcasHelper

  # presenta el reporte con detalles
  def reporte(klass, link = true)
    txt, uri = tipo_reporte(klass)
    if link
      link_to txt, uri 
    else
      txt
    end
  end

  # Retorna el tipo de reporte de acuerdo a si es un cruce o busqueda
  #  @param ReporteMarca
  #  @return [String, String] # texto, uri
  def tipo_reporte(klass)
    if klass.tipo_reporte == ReporteMarca::TIPO["Cruce"]
      [ "Cruce gaceta #{klass.importacion.publicacion} del #{l klass.importacion.publicacion_fecha}",
       reporte_marca_path(klass, :importacion_id => klass.importacion_id)]
    elsif klass.tipo_reporte == ReporteMarca::TIPO["Busqueda"]
      [ "Busqueda", reporte_marca_path(klass) ]
    elsif klass.tipo_reporte == ReporteMarca::TIPO["Lista Publicacion"]
      [ "Lista Publicacion #{klass.importacion.publicacion} del #{l klass.importacion.publicacion_fecha}",
       reporte_marca_path(klass, :importacion_id => klass.importacion_id)]
    end
  end

end
