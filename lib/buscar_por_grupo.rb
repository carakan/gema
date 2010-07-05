module BuscarPorGrupo


  def buscar_por_grupos(dim)
    l = busqueda.size - dim
    (0..l).each do |v| 
      @expresiones[2] << busqueda[v,dim]
    end
  end

  def buscar_equivalencias
    case 
      when [6,7].include?(busqueda.size)
        buscar_por_grupos(3)
      when [8,9].include?(busqueda.size)
        buscar_por_grupos(4)
      when [10,11].include?(busqueda.size)
        buscar_por_grupos(5)
      when [12,13].include?(busqueda.size)
        buscar_por_grupos(6)
      when [14,15].include?(busqueda.size)
        buscar_por_grupos(7)
      when [16,20].include?(busqueda.size)
        buscar_por_grupos(8)
    end

    expresiones_pares_impares
  end

end
