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
    if klass.importacion_id?    
      [ "Cruce gaceta #{klass.importacion.publicacion} del #{l klass.importacion.publicacion_fecha}",
       reporte_marca_path(klass, :importacion_id => klass.importacion_id)]
    else
      [ "Busqueda", reporte_marca_path(klass) ]
    end
  end

end
