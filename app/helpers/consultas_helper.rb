module ConsultasHelper
  def consulta_gaceta(consulta)
    if consulta and consulta.importacion_id > 0
      "Gaceta " + @consulta.importacion.publicacion
    end
  end
  
  def presentar_parametro(consulta, param)
    case param
      when :clases
        "<label>Clases</label> #{BusquedaVacia.label(consulta.parametros[param])}".html_safe
      when :fecha_ini
        "<label>Fecha inicial</label> #{ l Date.parse(consulta.parametros[param]) }".html_safe
      when :fecha_fin
        "<label>Fecha final</label> #{ l Date.parse(consulta.parametros[param]) }".html_safe
    end
  end

  def titulo_consulta(consulta)
    unless consulta.marca.nil?
      "Cruce de \"#{consulta.marca.nombre}\" #{consulta.marca.clase}"
    else 
      "Busqueda de \"#{consulta.busqueda}\""
    end
  end

end
