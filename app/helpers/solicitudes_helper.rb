module SolicitudesHelper

  # Presenta los links de edit y destroy
  def links_for_marca(klass, options = {})
    [ edit_link(klass, options), 
      destroy_link(klass, options) ].join(' ')
  end

  def edit_link(klass, opts = {})
    opts[:class] = "edit #{opts[:class]}"
    link_to 'editar', send( "edit_#{url_for_marca(klass)}", klass), opts
  end

  def destroy_link(klass, opts = {})
    opts[:class] = "delete"
    link_to 'borrar', send( "#{url_for_marca(klass)}", klass ), opts
  end


  # retorna el url para el show de marc
  # # retorna el url para el show de marcaa
  def url_for_marca(klass)
    case klass.estado
    when 'sm'
      'solicitud_marca_path'
    when 'lp'
      'lista_publicacion_path'
    end
  end

  def link_marca(text, klass, opts)
    link_to text, send( "#{url_for_marca(klass)}", klass ), opts
  end

  def link_importaciones(text, klass)
    if klass.errores.to_i > 0
      link_to text, importado_solicitud_path(klass.fecha_importacion, :mostrar => 'error')
    else
      link_to text, importado_solicitud_path(klass.fecha_importacion, :mostrar => 'all')
    end
  end

end
