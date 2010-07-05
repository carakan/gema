Array.class_eval do
  def repeated_combination(n = 0)
    arr = []
    self.rep_comb(n){ |x| arr << x }
    arr
  end

  def rep_comb(n = size)
    if size == 0 && n > 0 or n < 0
    elsif n == 0
      yield([])
    else
      (0...size).to_a.rep_comb(n - 1) do |x|
        ((x.empty? ? 0 : x.last)...size).each do |i|
          yield values_at *(x + [i])
        end
      end
    end
  end

  #Assumes self is an array of arrays and combines each array with each other array
  def combine
    combos = Array.new
    _combine(combos, [], 0)
    combos
  end

  def _combine(combos, combo, index)
    current = self.slice(index)
    if current
      current.each{|a|
        _combo = combo.dup
        _combo << a
        _combine(combos, _combo, index+1)
      }
    else
      combos << combo
    end
  end

end
