# encoding: utf-8
module ReportesHelper
  # Copiado de marcas
  def cliente_propio(a)
    a.cliente? ? "propia" : 'foranea'
  end
end
