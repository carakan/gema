module SeisLetras
  def buscar_equivalencias
    @expresiones = [{1 => busqueda}]

    @expresiones << {2 => busqueda[0,3]}
    @expresiones << {2 => busqueda[1,3]}
    @expresiones << {2 => busqueda[2,3]}
    @expresiones << {2 => busqueda[3,3]}

    expresiones_pares_impares
  end

  def expresiones_pares_impares
    par = ''
    impar = ''
    busqueda.chars.each_with_index do |chr, ind|
      unless (ind % 2) == 0
        par << chr
        impar << Constants::LETRAS_REG
      else
        par << Constants::LETRAS_REG
        impar << chr
      end
    end
    @expresiones << {3 => impar}
    @expresiones << {3 => par}
  end

end
