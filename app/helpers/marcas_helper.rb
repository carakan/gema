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
