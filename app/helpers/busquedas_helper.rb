module BusquedasHelper
  def tipo_busqueda(tipo)
    case tipo.to_i
      when 1 then "Exacta"
      when 2 then "Reemplazos"
      when 3 then "Fonética"
      when 4 then "División"
    end
  end
end
