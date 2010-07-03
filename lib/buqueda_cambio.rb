module BusquedaCambio

  @listado_silabas = [
    'ci', 'zi', 'si',
    'ce', 'ze', 'se',
    'ph', 'f',
    'gi', 'ji',
    'je', 'ge',
    'oo', 'cs',
    'ca', 'ka', 'qa',
    'cu', 'qu', 'ku',
    'co', 'qo', 'ko',
    'll', 'i', 'y',
    'b', 'v', 'h'
  ]


  @listado_silabas_equivalencias = {
    'ci-si-zi' => { :metodo => :intercambio_consonante, :lista => ['ci', 'zi', 'si'] },
    'ce-se-ze' => { :metodo => :intercambio_consonante, :lista => ['ce', 'ze', 'se'] },
    'ca-ka-qa' => { :metodo => :intercambio_consonante, :lista => ['ca', 'ka', 'qa'] },
    'cu-ku-qu' => { :metodo => :intercambio_consonante, :lista => ['cu', 'ku', 'qu'] },
    'co-ko-qo' => { :metodo => :intercambio_consonante, :lista => ['co', 'ko', 'qo'] },
    'gi-ji' => { :metodo => :intercambio_consonante, :lista => ['gi', 'ji'] },
    'ge-je' => { :metodo => :intercambio_consonante, :lista => ['ge', 'je'] },
    'ge-je' => { :metodo => :intercambio_consonante, :lista => ['ge', 'je'] },
    'f-ph' => { :metodo => :intercambio_consonante, :lista => ['f', 'ph'] },
    'oo' => { :metodo => :reemplazar_silaba, :lista => ['o', 'u'] },
    'cs' => { :metodo => :reemplazar_silaba, :lista => ['cs', 'x', 'cz'] },
    'll' => { :metodo => :reemplazar_silaba, :lista => ['l'] },
    'h' => { :metodo => :reemplazar_silaba, :lista => ['', 'j'] }
  }

  def cambios_consonantes(subexp)
    @listado_silabas.each do |sil| 
      if !!(subexp.index(silaba) )
        case
          when ['ci', 'si', 'zi'].include?(subexp) 
            cambio_csz(subexp, silaba)
        end
      end
    end
  end

  def cambio_cisizi(subexp, silaba)
    lista = ['ci', 'si', 'zi']
    lista.delete(silaba)
    
    lista.each{ |v| @expresiones << {4 => 1} }
  end

  # Realiza los cambios necesarios para una parabra
  def cambios_palabra_completa
    @listado_silabas.each do |silaba|
      if !!(busqueda.index(silaba) )
        cambio_palabra_silaba(silaba) 
      end
    end
  end

  # Cambio y busqueda por indice
  def cambio_palabra_silaba(silaba)
    if ind = 0
      @listado_silabas_equivalencias.each do |k,val|
        @indice_listado = k if !!k.index(silaba, ind)
      end
    end
    

  end

  def intercambio_consonante(silaba, indice)
    
  end

end
