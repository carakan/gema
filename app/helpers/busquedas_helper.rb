module BusquedasHelper
  def tipo_busqueda(tipo)
    case tipo.to_i
      when 1 then "Exacta"
      when 2 then "Reemplazos"
      when 3 then "Fonética"
      when 4 then "División"
    end
  end

  # Realiza la busqueda en una coleccion de representantes y retorna su nombre
  #  @param Array
  #  @param Array
  #  @return String
  def buscar_representante(representante_ids, representantes)
    representante_ids.map { |_id| representantes[_id] }.join(", ")
  end
end
