# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
module BusquedasHelper
  # Indica que tipo de resultado de fue encontrado "Exacta", "Reemplazos", etc.
  def tipo_busqueda(tipo)
    case tipo.to_i
    when 1 then "Exacta"
    when 2 then "Reemplazos"
    when 3 then "Fonética"
    when 4 then "División"
    else
      ""
    end
  end

  # Realiza la busqueda en una coleccion de representantes y retorna su nombre
  #  @param Array
  #  @param Array
  #  @return String
  def buscar_representante(representante_ids, representantes)
    representante_ids.map { |_id| representantes[_id] }.join(", ") if !representante_ids.nil? && !representante_ids.blank?
  end
  
  def parametros_busqueda(search)
    parametros = search
    x = []
    #y = []
    res = []
    parametros.each do |key, value|
      x = key.gsub(/equals|any|btw|btw_any|vista_marca|_n_|_a_|contains_all|_in/, "").gsub(/_/," ")
      #y << "#{parametros[key]}"
      if value.class == Array or value.class == Hash
        value = value.join(", ").html_safe
      end
      
      res << "#{x} = #{value}"
    end
      return "#{res.uniq.join("<br>")}".html_safe
      #return "Valores: #{y.uniq.join(", ")} Campos: #{x.uniq.join(", ")}"
  end

  # presenta de acuerdo al estado
  def numero_marca(marca)
    case marca.estado
    when "sm" then marca.numero_solicitud
    when "lp" then marca.numero_publicacion
    when "lr" then marca.numero_registro
    when "sr" then marca.numero_solicitud_renovacion
    when "rc" then marca.numero_renovacion
    else
      marca.numero_solicitud
    end
  end

  # presentar fecha de la marca
  def fecha_marca(marca)
    case marca.estado
    when "sm" then marca.fecha_solicitud
    when "lp" then marca.fecha_solicitud
    when "lr" then marca.fecha_registro
    when "sr" then marca.fecha_solicitud_renovacion
    when "rc" then marca.fecha_renovacion
    else
      marca.fecha_solicitud
    end
  end

  def llenar_datos_iguales(datos)
    [["Todas las marcas", "all_values"]] + datos.collect {|element| [ element.nombre, element.id]}
   
  end
end
