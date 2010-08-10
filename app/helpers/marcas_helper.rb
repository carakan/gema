module MarcasHelper
  # Presenta los campos con su label
  def presentar_campo_historial(klass, campo)
    if label_campos[campo].nil?
      %Q( <label>#{campo.humanize}</label> #{ klass.send(campo) } )
    else
      hash = label_campos[campo]
      %Q( <label>#{hash[:label]}</label> #{ klass.send(hash[:field]) } )
    end
  end


  # Indica si hay cambio en el campo
  def cambio(klass, attr, presentar = nil)
    attr = attr.to_s.gsub(/(.*)_id$/, '\1') if !!(attr.to_s =~ /.*_id$/)
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
