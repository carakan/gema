# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class BusquedaVacia < Tableless
  column :busqueda

  CLASES = [
    (1..45).to_a,
    [ 1, 2, 4 ],
    [ 3, 5, 10 ],
    [ 6, 14 ],
    [ 7, 8, 9, 11, 21 ],
    [ 17, 19, 20, 22 ],
    [ 18, 25 ],
    [ 22, 23, 24, 25, 26 ],
    [ 29, 30, 31 ],
    [ 32, 33 ],
    (34..45).to_a,
  ] + (1..45).to_a.map { |v| [v] }

  def self.options
    CLASES.map{ |v| 
      if v.size > 20
        ['Todas las clases', v.join(',')]
      elsif v.size > 8 
       ['34 al 45', v.join(',')]
      else
       [v.join(', '), v.join(',')]
      end
    }
  end

  def self.label(clases)
      if clases.size > 20
        'Todas las clases'
      elsif clases.size > 8 
       '34 al 45'
      else
       clases.join(', ')
      end
  end
end
