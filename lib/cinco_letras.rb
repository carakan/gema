# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
module CincoLetras

  def buscar_equivalencias
    #cambios_palabra_completa   

    @expresiones[2] << busqueda[0,3]
    @expresiones[2] << busqueda[1,3]
    @expresiones[2] << busqueda[2,3]

    @expresiones[3] << busqueda[0,2]
    @expresiones[3] << busqueda[3,2]
  end
end
