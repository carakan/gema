# enconding: utf-8
module TipoSignosHelper
  # retorna el tipo de sigla
  def tipo_signo_sigla(tipo_signo_id)
    @tipo_signos ||= TipoSigno.hash_siglas
    @tipo_signos[tipo_signo_id]
  end
end
