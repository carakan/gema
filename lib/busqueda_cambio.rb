# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
module BusquedaCambio

  def self.included(base)
    base.send(:extend, ClassMethods)
    base.send(:include, InstanceMethods)
  end

  module ClassMethods

    def listado_equivalencias
     @lista_equivalencias_dos_letras = {
        '(ci|si|zi)' =>  ['ci', 'zi', 'si'],
        '(ce|se|ze)' =>  ['ce', 'ze', 'se'],
        '(ca|ka|qa)' =>  ['ca', 'ka', 'qa'],
        '(cu|ku|qu)' =>  ['cu', 'ku', 'qu'],
        '(co|ko|qo)' =>  ['co', 'ko', 'qo'],
        '(gi|ji)' =>  ['gi', 'ji'],
        '(ge|je)' =>  ['ge', 'je'],
        '(oo)' =>  ['o', 'u', 'oo'],
        '(cc)' =>  ['cc', 'cs', 'cz', 'x'],
        '(ll)' =>  ['l', 'll'],
        '(ph|f)' =>  ['f', 'ph'],
        '(h)' =>  ['h','', 'j'],
        '(y|i)' => ['i', 'y'],
        '(v|b)' => ['b', 'v']
      }
    end

    # en caso de que exista ciertas excepciones
    # debe adicionar a algunas listas otros valores
    def listado_equivalencias_extra

    end

  end

  module InstanceMethods
    attr_reader :indices_palabra, :lista_equivalencias_dos_letras 

    # Realiza cambios en equivalencias
    # e = i || o = u
    #def buscar_equivalencias
    #  if !!( busqueda =~ /[eiou]/ )
    #    busqueda.chars.each_with_index do |v, ind|
    #      if !!( v =~ /[eiou]/ )
    #        @expresiones[2] << reemplazar_letra(v, ind)
    #      end
    #    end
    #  end
    #end


    # Realiza los cambios por silaba
    def cambios_silabas
      return true if busqueda.size < 4
    end

    # Crea todas las combinaciones de una palabra
    def combinaciones_palabra()
      buscar_indices_palabra
      arr = []

      obtener_array_silabas.combine.each do |comb|
        subpalabra = busqueda.dup
        sum_ind = 0

        comb.each_with_index do |elem, ind|
          pos = indices_palabra[ind].first 
          size = indices_palabra[ind].last[:size]
          
          pos_real = pos + sum_ind
          subpalabra[pos_real, size ] = elem
          sum_ind = elem.size - size + sum_ind
        end
        arr << subpalabra
      end
      arr.delete(busqueda)

      arr.uniq
    end


    # Buscas los indices de la palabra
    def buscar_indices_palabra
      @indices_palabra = []
      (0..(busqueda.size - 1)).each do |v|
        self.class.listado_equivalencias.each do |sil, val|
          if !!( busqueda[v,2] =~ /^#{sil}/ )
            @indices_palabra << [ v, {:size => $1.size, :vals => val} ]
          end
        end
      end
    end
   
    # retorna todos los arrays para combinar
    def obtener_array_silabas
      indices_palabra.inject([]) do |arr, h| 
        arr << h.last[:vals]
      end
    end

    #
    def intercambios_multilaterales

    end

    #
    def intercambios_unilaterales

    end

    # En caso de que existe ['si', 'se', 'zi', 'ze']
    # se debe aumentar mas conbinaciones a la lista
    #def extender_equivalencias(ind)
    #  if ['si', 'se'].include? busqueda[ind,2]
    #    if busqueda[ind, 2] == 'si'
    #      @lista_equivalencias_dos_letras.push('')
    #    else
    #    end
    #  elsif ['zi', 'ze'].include? busqueda[ind, 2]
    #    if !!(busqueda[ind,2] =~ /i/ )
    #      @lista_equivalencias_dos_letras['ci|si|zi'].push('c', 's', '')
    #    elsif !!(busqueda[ind, 2] =~ /e/ )

    #    end
    #  end
    #end
  end
end
