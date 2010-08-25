module MarcasHelper
  # Presenta los campos con su label
  def presentar_campo_historial(klass, campo)

    pres = presentar_campo_por_tipo(klass, campo)
    if label_campos[campo].nil?
      %Q( <label>#{campo.humanize}</label> #{ pres } )
    else
      hash = label_campos[campo]
      pres = klass.send(hash[:field])
      pres = pres.join(", ") if pres.is_a? Array
      %Q( <label>#{hash[:label]}</label> #{ pres } )
    end
  end

  def presentar_campo_por_tipo(klass, campo)
    unless label_campos[campo].nil?
      val = klass.send( label_campos[campo][:field] )
    else
      val = klass.send(campo)
    end
    txt = ''
    case true
      when [Date, Time, DateTime].include?( val.class )
        fecha val
      when [true, false].include?( val )
        valido_img(val)
      when campo.to_s == 'archivo_adjunto'
        "<img src=\"#{val}\" class=\"mini\" />"
      else
        val
    end

  end

  # Indica si hay cambio en el campo
  def cambio(klass, attr, presentar = nil)
    attr = attr.to_s.gsub(/(.*)_id$/, '\1') if !!(attr.to_s =~ /.*_id$/)
    if presentar.nil? and [true, false].include?( klass[attr] )
      presentar = valido(klass[attr])
    end

    if !klass.cambios.nil? and klass.cambios.include?(attr.to_s)
      if presentar.nil?
        "<span class='cambio'>#{klass.send(attr)}</span>"
      else
        "<span class='cambio'>#{presentar}</span>"
      end
    else
      if presentar.nil?
        klass.send(attr)
      else
        presentar
      end
    end
  end

  def buscar_clase(clase_id)
    @clases ||= Clase.all(:select => "id, nombre, codigo")
    
    unless clase_id.nil?
      @clases.find { |v| v.id == clase_id }
    end
  end
  
  def buscar_tipo_signo(tipo_signo_id)
    @signos ||= TipoSigno.all(:select => 'id, nombre')

    unless tipo_signo_id.nil?
      @signos.find { |v| v.id == tipo_signo_id }
    end
  end
  
  # Presenta un tr indicando si es propia y presentado
  # los errores dependiendo si se elija la opcion error
  # para presentar
  #   @param Marca
  #   @param [true, false]
  #   @return String
  def tr_marca(marca, error = true)
    css = marca.propia ? 'propia' : ''
    alt = ''

    unless not error or marca.valido
      css << ' error'
      alt << %Q(alt="#{marca.presentar_errores}")
    end
    
    "<tr class=\"#{css}\" #{alt}>"
  end


  def opciones_extra(options)
    options.map { |v| "#{v.first}=\"#{v.last}\"" }.join(" ")
  end

  def mostrar_imagen(marca)
    if [2, 3, 4].include? marca.tipo_signo_id
      image_tag marca.adjuntos.first.archivo.url(:mini), :class => 'mini'
    end
  end

private
  # Relacion entre campos y el historico
  def label_campos
    {
      'clase_id' => {:label => 'Clase', :field => 'clase' },
      'pais_id' => {:label => 'Pais', :field => 'pais' },
      'usuario_id' => {:label => 'Usuario', :field => 'usuario' },
      'agente_ids_serial' => { :label => 'Agentes', :field => 'agentes_serial'},
      'titular_ids_serial' => { :label => 'Titulares', :field => 'titulares_serial'}
    }
  end
end
