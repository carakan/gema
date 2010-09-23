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
    representante_ids.map { |_id| representantes[_id] }.join(", ") unless representante_ids.blank?
  end
end
