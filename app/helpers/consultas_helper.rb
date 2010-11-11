module ConsultasHelper
  def consulta_gaceta(consulta)
    if consulta and consulta.importacion_id > 0
      "Gaceta " + @consulta.importacion.publicacion
    end
  end
  
  def presentar_parametro(consulta, param)
    html = ""
    case param
      when :clases
        html = "<label>Clases</label> #{ BusquedaVacia.label(consulta.parametros[param]) }"
      when :fecha_ini
        html = "<label>Fecha inicial</label> #{ l Date.parse(consulta.parametros[param]) }"
      when :fecha_fin
        html = "<label>Fecha final</label> #{ l Date.parse(consulta.parametros[param]) }"
    end

    html.html_safe
  end

  def titulo_consulta(consulta)
    unless consulta.marca.nil?
      "Cruce de \"#{consulta.marca.nombre}\" #{consulta.marca.clase}"
    else 
      "Busqueda de \"#{consulta.busqueda}\""
    end
  end

end
