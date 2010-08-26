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
    link_to "cruzar", cruce_busquedas_path(query), :class => 'nueva'
  end

  def ver_cruce(consulta, options = {})
    if consulta.descartada
      options[:class] = options[:class].to_s + ' fail'
      link_to "descartado", consulta_path(consulta, :page => @page), options
    else
      options[:class] = options[:class].to_s + ' succeed'
      link_to "cruzado", consulta_path(consulta, :page => @page), options
    end
  end

  def gaceta(importacion)
    unless importacion.publicacion.nil?
      "Gaceta #{importacion.publicacion}, "
    else
      ""
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
