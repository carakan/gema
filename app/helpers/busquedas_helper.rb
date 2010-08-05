module BusquedasHelper
  def tipo_busqueda(tipo)
    case tipo.to_i
      when 1 then "Exacta"
      when 2 then "Fonética"
      when 3 then "División"
      when 4 then "División"
    end
  end
end
