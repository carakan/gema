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
    representante_ids.map { |_id| representantes[_id] }.join(", ") unless representante_ids.blank?
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
end
