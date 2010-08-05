module ImportacionesHelper
  # Link que presenta en importaciones si se realizo los cruces
  def cruce(marca)
    case marca.try(:estado)
      when 'lp'
        link_cruce(marca)
      else
        ""
    end
  end


  # Presenta un vinculo relacionado al cruce de una marca
  def cruce_busqueda(marca, importacion)
<<<<<<< HEAD
    if consulta = marca.cruce(importacion.id)
      link_to "ver cruce", cosulta.id
    else
      link_to "realizar cruce"
    end
  end

  protected
=======
    if imp = marca.cruce(importacion.id)
      link_to "ver cruce", imp.id
    else
      link_to "realizar cruce", busquedas_path(:importacion_id => importacion.id, :busqueda => marca.nombre, :clases => (1..45).to_a.join(',') )
    end
  end

protected
>>>>>>> 4718b47b21cd05b683ad145ecdf6cd2d9454d64f
  def link_cruce(marca)
    imp = marca.importacion
    if imp.cruces_pendientes < 0
      link_to "Realizar cruce gaceta #{imp.publicacion}", cruce_importacion_path(imp.id)
    elsif imp.cruces_pendientes > 0
      link_to "Faltan #{imp.cruces_pendientes} cruces", cruce_importacion_path(imp.id)
    else
      link_to "Ver cruces", cruce_importacion_path(imp.id)
    end
  end
end
