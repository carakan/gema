class BusquedaVacia < Tableless
  column :busqueda

  CLASES = [
    [ 1, 2, 4 ],
    [ 3, 5, 10 ],
    [ 6, 14 ],
    [ 7, 8, 9, 11, 21 ],
    [ 12 ],
    [ 13 ],
    [ 15 ],
    [ 16 ],
    [ 17, 19, 20, 22 ],
    [ 18, 25 ],
    [ 22, 23, 24, 25, 26 ],
    [ 28 ],
    [ 29, 30, 31 ],
    [ 32, 33 ],
    [ 34 ],
    (34..45).to_a 
  ]

  def self.options
    arr = CLASES.map{ |v| 
      if v.size > 8 
       ['34 al 45', v.join(',')]
      else
       [v.join(', '), v.join(',')]
      end
    }
  end
end
