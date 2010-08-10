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
  def realizar_cruce(marca, importacion, consulta_id)
    query = { :importacion_id => importacion.id, :marca_id => marca.id, :page => @page }
    query.merge!(:consulta_id => consulta_id ) unless consulta_id.nil?
    link_to "realizar cruce", cruce_busquedas_path(query), :class => 'nueva'
  end

  def ver_cruce(consulta)
    if consulta.descartada
      link_to "Ver descarte", consulta_path(consulta, :page => @page), :class => "fail"
    else
      link_to "Ver cruce", consulta_path(consulta, :page => @page), :class => 'succeed'
    end
  end

protected
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
