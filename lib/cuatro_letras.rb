module CuatroLetras
  
  def buscar_equivalencias
    @expresiones = [{1 => busqueda}]
    @expresiones << {2 => busqueda[0,3]}
    @expresiones << {2 => busqueda[1,3]}
  end
end
