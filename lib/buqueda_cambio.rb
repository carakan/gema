module BusquedaCambio

  def self.included(base)
    base.send(:extend, ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods

    def listado_silabas_equivalencias
      @listado_silabas_equivalencias = {
        'ci|si|zi' =>  ['ci', 'zi', 'si'],
        'ce|se|ze' =>  ['ce', 'ze', 'se'],
        'ca|ka|qa' =>  ['ca', 'ka', 'qa'],
        'cu|ku|qu' =>  ['cu', 'ku', 'qu'],
        'co|ko|qo' =>  ['co', 'ko', 'qo'],
        'gi|ji' =>  ['gi', 'ji'],
        'ge|je' =>  ['ge', 'je'],
        'f|ph' =>  ['f', 'ph'],
        'oo' =>  ['o', 'u'],
        'cs' =>  ['cs', 'x', 'cz'],
        'll' =>  ['l'],
        'h' =>  ['', 'j']
      }
    end

  end

  module InstanceMethods
    attr_reader :indices_palabra

    # Realiza cambios en equivalencias
    # e = i || o = u
    def buscar_equivalencias
      if !!( busqueda =~ /[eiou]/ )
        busqueda.chars.each_with_index do |v, ind|
          if !!( v =~ /[eiou]/ )
            @expresiones[2] << reemplazar_letra(v, ind)
          end
        end
      end
    end


    # Realiza los cambios por silaba
    def cambios_silabas
      return true if busqueda.size < 4

      @expresiones[2].each do |subexp|
      end

      @listado_silabas.each do |sil| 
        if !!(subexp.index(silaba) )
          case
            when ['ci', 'si', 'zi'].include?(subexp) 
              cambio_csz(subexp, silaba)
          end
        end
      end
    end

    # Crea todas las combinaciones de una palabra
    def combinaciones_palabra()
      buscar_indices_palabras
      arr = []

      obtener_array_silabas.combine.each do |comb|
        subpalabra = busqueda.dup
        comb.each_with_index do |elem, ind|
          subpalabra[indices_palabra.keys[ind], 2 ] = elem
        end
        arr << subpalabra
      end

      arr
    end

    # Buscas los indices de la palabra
    def buscar_indices_palabras
      @indices_palabra = {}
      (0..(busqueda.size - 2)).each do |v|
        self.class.listado_silabas_equivalencias.each do |sil, val|
          @indices_palabra[v] = sil if !!( busqueda[v,2] =~ /#{sil}/ )
        end
      end
    end
   
    # retorna todos los arrays para combinar
    def obtener_array_silabas
      indices_palabra.inject([]) do |arr, h| 
        arr << self.class.listado_silabas_equivalencias[h.last]
      end
    end


    #
    def intercambios_multilaterales

    end

    #
    def intercambios_unilaterales

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
end
