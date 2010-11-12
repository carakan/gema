# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
module CuatroLetras
  
  def buscar_equivalencias
    @expresiones[2] << busqueda[0,3]
    @expresiones[2] << busqueda[1,3]
  end
end
