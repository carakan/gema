# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
module TresLetras

  # Realiza cambios en equivalencias
  # e = i || o = u
  def buscar_equivalencias
    arr = []
    if !!( busqueda =~ /[eiou]/ )
      busqueda.chars.each_with_index do |v, ind|
        if !!( v =~ /[eiou]/ )
           arr << reemplazar_letra(v, ind)
        end
      end
    end

    arr
  end

  # cambia la letra con el indice indicado
  def reemplazar_letra(letra, ind)
    # Necesario duplicar el objeto sino se modifica la variable original
    tmp = busqueda.dup

    case letra
    when 'e'
      tmp[ind,1] = 'i'
    when 'i'
      tmp[ind,1] = 'e'
    when 'o'
      tmp[ind,1] = 'u'
    when 'u'
      tmp[ind,1] = 'o'
    end

    tmp
  end
end
