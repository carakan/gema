module BuscarPorGrupo


  def buscar_por_grupos(dim)
    letras = []
    l = @letras.size - dim

    arr = []
    (0..l).each do |v|
      arr << @letras[v,dim].join
    end

    arr
  end


  def buscar_equivalencias

    case 
      when (4..7).include?(@letras.size)
        buscar_por_grupos(3)
      when [8, 9].include?(@letras.size)
        buscar_por_grupos(4)
      when [10, 11].include?(@letras.size)
        buscar_por_grupos(5)
      when [12, 13].include?(@letras.size)
        buscar_por_grupos(6)
      when [14, 15].include?(@letras.size)
        buscar_por_grupos(7)
      when (16..20).include?(@letras.size)
        buscar_por_grupos(8)
    end

  end

end
